function times=cusum_online(filename,par,thresh,varargin)

filename_back=strcat(char(filename),'-Xsens-Ceinture.csv');
filename_foot=strcat(char(filename),'-Xsens-Pied Droit.csv');

[back_acc,back_gyr,fs_back]=import_csv_xsens(filename_back);
[foot_acc,foot_gyr,fs_foot]=import_csv_xsens(filename_foot);
back_acc_norm=sqrt(back_acc(:,1).^2+back_acc(:,2).^2+back_acc(:,3).^2);
foot_acc_norm=sqrt(foot_acc(:,1).^2+foot_acc(:,2).^2+foot_acc(:,3).^2);
vert_back_gyr=back_gyr(:,3);
y=[back_acc , foot_acc];

N = size(y, 1) ;

p=inputParser;
addRequired(p,'filename',@iscellstr);
addRequired(p,'par');
addRequired(p,'thresh');
addParameter(p,'plt','b',@(x) any(validatestring(x,{'y','n','b'})));
addParameter(p,'mu',mean(y,1),@isnumeric) ;
addParameter(p,'sigma',std(y,1),@isnumeric) ;
addParameter(p, 'coef', ones(N, 1), @isnumeric) ;
parse(p,filename,par,thresh,varargin{:});
plt=p.Results.plt;
mu = p.Results.mu ;
sigma = p.Results.sigma ;
coef = p.Results.coef ;

times=all_online(y,par,thresh,'mu',mu,'sigma',sigma,'coef',coef);

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
        line([times(i) times(i)],[min_y max_y],'Color','k','linewidth',2)
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