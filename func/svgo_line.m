function svgo_line(fid,x,y,color,width)
% SVGO_LINE  Write SVG object: line
if nargin<5; width=1; end
if nargin<4; color='#000000'; end

if all(round([x,y])==[x,y])
    ff = '%03d';
else
    ff = '%06.2f';
end
if length(x)==1
    x=[x,x];
end
if length(y)==1
    y=[y,y];
end

fprintf(fid,[ ...
    '<line x1="',ff,'" x2="',ff,'" y1="',ff,'" y2="',ff,'" ',...
    'style="stroke:%s;stroke-width:%s"/>\n'],...
    x(1),x(2),y(1),y(2),color,num2str(width));   