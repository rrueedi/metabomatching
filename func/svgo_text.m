function svgo_text(fid,x,y,txt,horiz,fsize,fweight,fcolor,fstyle)
% SVGO_TEXT  Write SVG object: text
global fontsize 
if nargin<9; fstyle='normal';  end
if nargin<8; fcolor='black';   end
if nargin<7; fweight='normal'; end
if nargin<6; fsize=fontsize;   end
if nargin<5; horiz='middle';   end

str = 'text ';
if round(x)==x && round(y)==y
    str = [str,sprintf('x="%03d" y="%03d"',x,y)];
else
    str = [str,sprintf('x="%06.2f" y="%06.2f"',x,y)];
end
str = [str,sprintf(' font-size="%02d"',fsize)];
str = [str,' font-family="Open Sans"'];
if ~strcmp(fweight,'normal'); str = [str,sprintf(' font-weight="%s"',fweight)]; end
if ~strcmp(fstyle, 'normal'); str = [str,sprintf(' font-style="%s"' ,fstyle )]; end
if ~strcmp(fcolor, 'black' ); str = [str,sprintf(' fill="%s"'       ,fcolor )]; end
if ~strcmp(horiz,  's'     ); str = [str,sprintf(' text-anchor="%s"',horiz  )]; end
fprintf(fid,'<%s>%s</text>\n',str,txt);
