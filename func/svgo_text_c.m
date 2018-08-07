function svgo_text_c(fid,x,y,txt,class,horiz)
% SVGO_TEXT_C  Write SVG object: line, style by class
if nargin<6
    horiz='middle';
end
global fontsize

switch class
    case 'howto'
        svgo_text(fid,x,y,txt,horiz,fontsize+2,'normal','#e31a1c');
    case 'normal'
        svgo_text(fid,x,y,txt,horiz,fontsize,'normal','black');
    case 'heading'
        svgo_text(fid,x,y,txt,horiz,fontsize,'bold','black');
    case 'legend'
        svgo_text(fid,x,y,txt,horiz,fontsize-1,'normal','black');
    case 'control'
        svgo_text(fid,x,y,txt,horiz,fontsize,'normal','black');
end