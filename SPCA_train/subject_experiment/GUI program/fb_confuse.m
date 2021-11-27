function [err, err_each, num_conf, rate_conf] = fb_confuse(aglRef, angles)
% FB_CONFUSE(angles) is a function counting the confused front and back
% angles in the input mat.
% The outputs of this function contain three variables. One is a matrix the
% same size as the input angles and each element in it indicates that
% whether the corresponding angle of current element is confused. The other
% two variables are not necessarily need for output. The fisrt, i.e. the 
% second variable, records the confusing numbers of the input angles. The
% third records the confusing rate of the input angles.
%
% Modified at 2017/05/05
% Increased one argument to output the errors, which has removed the
% confusion of front and back, of the given angles.

% copyright(c) Ge Zhongshu 2017/04/27.
angl = aglRef;
angl_conf = repmat(mod(180-angl, 360), 1, 3);
angls = angles;
angl3 = repmat(angl, 1, 3);
dlt = 5;
confuse = ((angl3<90-dlt | angl3>270+dlt)&(angls>90+dlt & angls<270-dlt))|...
    ((angls<90-dlt | angls>270+dlt)&(angl3>90+dlt & angl3<270-dlt));
contrast = repmat(angl, 1, 3);
contrast(confuse) = angl_conf(confuse);
err = abs(angles(:) - contrast(:));
err(err>180) = 360 - err(err>180);
err_each = err;
err = mean(err);

[ic, jc] = find(confuse);
xconf = angl(ic);
conf = angls(sub2ind(size(confuse),ic,jc));
if(nargout>2);num_conf = length(ic);end
if(nargout>3);rate_conf = num_conf/length(angles(:));end

[ic, jc] = find(~confuse);
xcorrect = angl(ic);
correct = angls(sub2ind(size(confuse),ic,jc));
confuse = confuse(:);

if(nargout<1)
    figure(100);clf;
    h = plot(xconf, conf, 'r*', xcorrect, correct, 'ko');
    s = zeros(1,3);
    m = (150:30:210);
    b = ones(1,3)*360;
    hold on
    plot([[s, m, 0]; [m, b, 360]], [[m, b, 0]; [s, m, 360]], 'k--');
    if(~isempty(xconf));legend(h, '»ìÏý½Ç¶È', 'Î´»ìÏý½Ç¶È', 'Location' , 'NorthEastOutside');end
    set(gca, 'XTick', 0:30:360, 'YTick', 0:30:360);
    grid on
    axis equal
    axis([0 360 0 360]);
end
end