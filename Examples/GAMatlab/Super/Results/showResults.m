% Load ga_output
close all;


figure;plot(state.allBestInd);
title('Best Population');

figure;
col = hsv(30);
title('Best Population');
for i = 1:state.Generation
    hold on;
    i
    plot(state.allSchedule{i}','color',col(i,:));
    pause(1);
end

figure;
title('Best Population');
for i = 1:state.Generation
    plot(state.allBestInd(i,:)','color',col(i,:));
    axis([0 25 -30 -10]);
    pause(1);
end


figure;plot(state.allBestScore);
title('Fitness Function');