function [times,values]=cusum_seg_lin(filename,par,rupt,varargin)

% Giving two associated cognac-g signal 'filename_back' and
% 'filename-foot', extract them from .csv to variables. Then produce the
% acceleration (euclidian) norm for both back and foot, and put them in a
% signal with back vertical gyroscopy also.
% Run a dikt_cusum on this three variables signal ('nstep' default value is
% base 2 loagrithm of input size).
% dikt_cusum output is thresolded by 'hperc' percent of the max (0 gives
% all, 100 none) (default value is 0).
% The selected parameter 'par' is 'both' by default.
% If you know there are x changes, ask 'rupt',x. It will select the x most
% likely changes among all computed according CUSUM method.
% If you don't want a graphic output, ask 'plt','n'. Ask 'plt','y' for
% graphic results on original signals.

filename_back=strcat(char(filename),'-Xsens-Ceinture.csv');
filename_foot=strcat(char(filename),'-Xsens-Pied Droit.csv');

[back_acc,back_gyr,fs_back]=import_csv_xsens(filename_back);
[foot_acc,foot_gyr,fs_foot]=import_csv_xsens(filename_foot);
back_acc_norm=sqrt(back_acc(:,1).^2+back_acc(:,2).^2+back_acc(:,3).^2);
foot_acc_norm=sqrt(foot_acc(:,1).^2+foot_acc(:,2).^2+foot_acc(:,3).^2);
vert_back_gyr=back_gyr(:,3);
y=[back_acc_norm , foot_acc_norm, vert_back_gyr];

N = size(y, 1) ;

p=inputParser;
addRequired(p,'filename',@iscellstr);
addRequired(p,'par');
addParameter(p,'plt','b',@(x) any(validatestring(x,{'y','n','b'})));
addRequired(p,'rupt',@isnumeric);
addParameter(p,'mu',mean(y,1),@isnumeric) ;
addParameter(p,'sigma',std(y,1),@isnumeric) ;
addParameter(p, 'coef', ones(N, 1), @isnumeric) ;
parse(p,filename,par,rupt,varargin{:});
plt=p.Results.plt;
rupt=p.Results.rupt;
mu = p.Results.mu ;
sigma = p.Results.sigma ;
coef = p.Results.coef ;


[times,values]=dikt_cusum_lin(y,par,rupt,'mu',mu,'sigma',sigma,'coef',coef);

timeline_back=(1:size(back_gyr,1))/fs_back;
times=timeline_back(times);

if plt=='y' || plt=='b'
    
    figure
    hold on
    title([filename_back filename_foot])
    plot(timeline_back,y)
    max_y=max(max(y));
    min_y=min(min(y));
    for i=1:length(times)
        line([times(i) times(i)],[min_y max_y],'Color','k')
    end
    if plt=='y'
        
        figure
        subplot(2,3,1)
        plot(timeline_back,back_acc(:,1))
        title('back anteropost acc')
        ylabel('(m/s/s)')
        xlabel('Time (s)')
        max_y=max(max(back_acc));
        min_y=min(min(back_acc));
        for i=1:length(times)
            line([times(i) times(i)],[min_y max_y],'Color','k')
        end
        subplot(2,3,2)
        plot(timeline_back,back_acc(:,2))
        title('back mediolat acc')
        ylabel('(m/s/s)')
        xlabel('Time (s)')
        for i=1:length(times)
            line([times(i) times(i)],[min_y max_y],'Color','k')
        end
        subplot(2,3,3)
        plot(timeline_back,back_acc(:,3))
        title('back vert acc')
        ylabel('(m/s/s)')
        xlabel('Time (s)')
        for i=1:length(times)
            line([times(i) times(i)],[min_y max_y],'Color','k')
        end
        subplot(2,3,4)
        plot(timeline_back,back_gyr(:,1))
        title('back anteropost gyr')
        ylabel('(rad/s)')
        xlabel('Time (s)')
        max_y=max(max(back_gyr));
        min_y=min(min(back_gyr));
        for i=1:length(times)
            line([times(i) times(i)],[min_y max_y],'Color','k')
        end
        subplot(2,3,5)
        plot(timeline_back,back_gyr(:,2))
        title('back mediolat gyr')
        ylabel('(rad/s)')
        xlabel('Time (s)')
        for i=1:length(times)
            line([times(i) times(i)],[min_y max_y],'Color','k')
        end
        subplot(2,3,6)
        plot(timeline_back,back_gyr(:,3))
        title('back vert gyr')
        ylabel('(rad/s)')
        xlabel('Time (s)')
        for i=1:length(times)
            line([times(i) times(i)],[min_y max_y],'Color','k')
        end
        
        timeline_foot=(1:size(foot_gyr,1))/fs_foot;
        
        figure
        subplot(2,3,1)
        plot(timeline_foot,foot_acc(:,1))
        title('foot anteropost acc')
        ylabel('(m/s/s)')
        xlabel('Time (s)')
        max_y=max(max(foot_acc));
        min_y=min(min(foot_acc));
        for i=1:length(times)
            line([times(i) times(i)],[min_y max_y],'Color','k')
        end
        subplot(2,3,2)
        plot(timeline_foot,foot_acc(:,2))
        title('foot mediolat acc')
        ylabel('(m/s/s)')
        xlabel('Time (s)')
        for i=1:length(times)
            line([times(i) times(i)],[min_y max_y],'Color','k')
        end
        subplot(2,3,3)
        plot(timeline_foot,foot_acc(:,3))
        title('foot vert acc')
        ylabel('(m/s/s)')
        xlabel('Time (s)')
        for i=1:length(times)
            line([times(i) times(i)],[min_y max_y],'Color','k')
        end
        subplot(2,3,4)
        plot(timeline_foot,foot_gyr(:,1))
        title('foot anteropost gyr')
        ylabel('(rad/s)')
        xlabel('Time (s)')
        max_y=max(max(foot_gyr));
        min_y=min(min(foot_gyr));
        for i=1:length(times)
            line([times(i) times(i)],[min_y max_y],'Color','k')
        end
        subplot(2,3,5)
        plot(timeline_foot,foot_gyr(:,2))
        title('foot mediolat gyr')
        ylabel('(rad/s)')
        xlabel('Time (s)')
        for i=1:length(times)
            line([times(i) times(i)],[min_y max_y],'Color','k')
        end
        subplot(2,3,6)
        plot(timeline_foot,foot_gyr(:,3))
        title('foot vert gyr')
        ylabel('(rad/s)')
        xlabel('Time (s)')
        for i=1:length(times)
            line([times(i) times(i)],[min_y max_y],'Color','k')
        end
    end
end

end