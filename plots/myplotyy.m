function [] = myplotyy(haxes,t1,sig1,fs1,t2,sig2,label)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

axes(haxes)
cla reset
set(haxes,'XMinorTick','on')
axis tight
yticks('auto')
grid on
if ~isempty(sig2); yyaxis left; end;
plot(t1, sig1);
set(get(gca,'YLabel'), 'Rotation',0, 'VerticalAlignment','middle', 'HorizontalAlignment','right')
ylabel(label)
xlim([-Inf, Inf])
ylim([min(sig1(round(fs1*15):end-round(fs1*15))) max(sig1(round(fs1*15):end-round(fs1*15)))])
if ~isempty(sig2)
    yyaxis right
    plot(t2, sig2);
    ylim([min(sig2) max(sig2)])
    linkaxes(gca,'x');
end

end

