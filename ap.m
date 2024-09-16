function [] = ap(DeepMIMO_dataset)
%% COMPUTING AP LOCATIONS
APloc = zeros(2,3);
APloc(1,:) = DeepMIMO_dataset{1}.basestation{1}.loc;
APloc(2,:) = DeepMIMO_dataset{1}.basestation{2}.loc;
%% AP LOCATIONS PLOT
figure(23)
scatter(APloc(1,1),APloc(1,2),'go','DisplayName','Licensed AP','LineWidth',3)
hold on
scatter(APloc(2,1),APloc(2,2),'ko','DisplayName','Unlicensed AP','LineWidth',3)
hold on
grid minor
% legend
end