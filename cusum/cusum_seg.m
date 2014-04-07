function [times,values]=cusum_seg(filename_back,filename_foot,nstep,varargin)

% Giving two associated cognac-g signal 'filename_back' and
% 'filename-foot', extract them from .csv to variables. Then produce the
% acceleration (euclidian) norm for both back and foot, and put them in a
% signal with back vertical gyroscopy also. Run a 'nstep' dikt_cusum on
% this three variables signal. Finally the output is dikt_cusum one,
% thresold 'hperc' percent of the max (0 gives all, 100 none). The selected
% parameter 'par' is 'mean' by default. So as the 'weight' is 'none'. If
% you don't want a graphic output, ask 'plt','n'.

p=inputParser;
addRequired(p,'filename_back',@isstr);
addRequired(p,'filename_foot',@isstr);
addRequired(p,'nstep',@isnumeric);
addParameter(p,'hperc',0,@(x) 0<=x<=100);
addParameter(p,'par','both',@(x) any(validatestring(x,{'std','mean','both'})));
addParameter(p,'plt','y',@(x) any(validatestring(x,{'y','n'})));
parse(p,filename_back,filename_foot,nstep,varargin{:});
hperc=p.Results.hperc;
par=p.Results.par;
plt=p.Results.plt;

[back_acc,back_gyr,fs]=import_csv_xsens(filename_back);
[foot_acc,foot_gyr,fs]=import_csv_xsens(filename_foot);

back_acc_norm=sqrt(back_acc(:,1).^2+back_acc(:,2).^2+back_acc(:,3).^2);
foot_acc_norm=sqrt(foot_acc(:,1).^2+foot_acc(:,2).^2+foot_acc(:,3).^2);
vert_back_gyr=back_gyr(:,3);

y=[back_acc_norm , foot_acc_norm, vert_back_gyr];

[times,values]=dikt_cusum(y,par,nstep);

t=(1:size(foot_gyr,1))/fs;
times(values<(hperc/100)*max(values))=[];
times=t(times);
values(values<(hperc/100)*max(values))=[];

if plt=='y'
    
    figure
    hold on
    title([filename_back filename_foot])
    plot(t,y)
    max_y=max(max(y));
    min_y=min(min(y));
    for i=1:length(times)
        line([times(i) times(i)],[min_y max_y],'Color','k')
    end
    
    figure
    subplot(2,3,1)
    plot(t,back_acc(:,1))
    title('back anteropost acc')
	ylabel('(m/s/s)')
    xlabel('Time (s)')
    max_y=max(max(back_acc));
    min_y=min(min(back_acc));
    for i=1:length(times)
        line([times(i) times(i)],[min_y max_y],'Color','k')
    end
    subplot(2,3,2)
    plot(t,back_acc(:,2))
    title('back mediolat acc')
    ylabel('(m/s/s)')
    xlabel('Time (s)')
    for i=1:length(times)
        line([times(i) times(i)],[min_y max_y],'Color','k')
    end
    subplot(2,3,3)
    plot(t,back_acc(:,3))
    title('back vert acc')
	ylabel('(m/s/s)')
    xlabel('Time (s)')
    for i=1:length(times)
        line([times(i) times(i)],[min_y max_y],'Color','k')
    end
    subplot(2,3,4)
    plot(t,back_gyr(:,1))
    title('back anteropost gyr')
	ylabel('(rad/s)')
    xlabel('Time (s)')
    max_y=max(max(back_gyr));
    min_y=min(min(back_gyr));
    for i=1:length(times)
        line([times(i) times(i)],[min_y max_y],'Color','k')
    end
    subplot(2,3,5)
    plot(t,back_gyr(:,2))
    title('back mediolat gyr')
    ylabel('(rad/s)')
    xlabel('Time (s)')
    for i=1:length(times)
        line([times(i) times(i)],[min_y max_y],'Color','k')
    end
    subplot(2,3,6)
    plot(t,back_gyr(:,3))
    title('back vert gyr')
    ylabel('(rad/s)')
    xlabel('Time (s)')
    for i=1:length(times)
        line([times(i) times(i)],[min_y max_y],'Color','k')
    end
    
    figure
    subplot(2,3,1)
    plot(t,foot_acc(:,1))
    title('foot anteropost acc')
    ylabel('(m/s/s)')
    xlabel('Time (s)')
    max_y=max(max(foot_acc));
    min_y=min(min(foot_acc));
    for i=1:length(times)
        line([times(i) times(i)],[min_y max_y],'Color','k')
    end
    subplot(2,3,2)
    plot(t,foot_acc(:,2))
    title('foot mediolat acc')
    ylabel('(m/s/s)')
    xlabel('Time (s)')
    for i=1:length(times)
        line([times(i) times(i)],[min_y max_y],'Color','k')
    end
    subplot(2,3,3)
    plot(t,foot_acc(:,3))
    title('foot vert acc')
    ylabel('(m/s/s)')
    xlabel('Time (s)')
    for i=1:length(times)
        line([times(i) times(i)],[min_y max_y],'Color','k')
    end
    subplot(2,3,4)
    plot(t,foot_gyr(:,1))
    title('foot anteropost gyr')
    ylabel('(rad/s)')
    xlabel('Time (s)')
    max_y=max(max(foot_gyr));
    min_y=min(min(foot_gyr));
    for i=1:length(times)
        line([times(i) times(i)],[min_y max_y],'Color','k')
    end
    subplot(2,3,5)
    plot(t,foot_gyr(:,2))
    title('foot mediolat gyr')
    ylabel('(rad/s)')
    xlabel('Time (s)')
    for i=1:length(times)
        line([times(i) times(i)],[min_y max_y],'Color','k')
    end
    subplot(2,3,6)
    plot(t,foot_gyr(:,3))
    title('foot vert gyr')
    ylabel('(rad/s)')
    xlabel('Time (s)')
    for i=1:length(times)
        line([times(i) times(i)],[min_y max_y],'Color','k')
    end
    
end

end