function AnalyzeArticle(url)
% Analyze Japanese Text Data
% https://jp.mathworks.com/help/textanalytics/ug/analyze-japanese-text.html

% close all;
% clear;
% clc;

%% Analyze Japanese Text Data

% url = "https://www.niigata-u.ac.jp/news/2021/92693/";
options = weboptions('CharacterEncoding','UTF-8');
code = webread(url,options);
%% 
% Extract the text data from the HTML using |extractHTMLText|. Split the text 
% by |newline| characters.

textData = extractHTMLText(code);
textData = string(split(textData,newline));

%% 
% Remove the empty lines of text.

idx = textData == "";
textData(idx) = [];

%% 
% Visualize the text data in a word cloud.

fig = figure;
wordcloud(textData);

%% output page

tree = htmlTree(code);
htmltitletext = string(findElement(tree,"title"));
htmltitletext = extractBetween(htmltitletext,'>',' | ');
htmltitletext = replace(htmltitletext,' ','_');
% todaydatetime = string(datetime('today','Format','yyyy-MM-dd'));
newsdatetime = string(datetime(strtrim(extractBetween(string(findElement(tree,'article')),'<DIV id="news_day">','日')),'InputFormat','yyyy年MM月dd','Format','yyyy-MM-dd'));

if all(size(newsdatetime) == [0 1])
    datepattern = digitsPattern(4)+lettersPattern(1,2)+digitsPattern(1,2)+lettersPattern(1,2)+digitsPattern(1,2);
    newsdatetime = extract(htmltitletext,datepattern);
    newsdatetime = string(datetime(newsdatetime,'InputFormat','yyyy年MM月dd','Format','yyyy-MM-dd'));

end
pagefilename = newsdatetime + '-' + htmltitletext + '.md';
imagehash = hashcalc(htmltitletext);
imagefilename = imagehash + '.png';


frontmatter = ["---" + newline +...
'layout: post'+ newline +...
'title:  "Welcome to Jekyll!"'+ newline +...
'---'];

pagecontent = [frontmatter + newline +...
    "TESTMATLAB ![wordcloud](" + "{{ site.baseurl }}/assets/" + imagefilename + ")"];

fileID = fopen("./docs/_posts/" + pagefilename,'w');
fprintf(fileID,'%s',pagecontent);
fclose(fileID);

saveas(fig,"./docs/assets/" + imagefilename)
close;
% _Copyright 2018 The MathWorks, Inc._


%% Hash calculation function
function out = hashcalc(in)
%https://jp.mathworks.com/matlabcentral/answers/45323-how-to-calculate-hash-sum-of-a-string-using-java
% Import HASH calculation package
import java.security.*;
import java.math.*;
testname = char(strjoin(string(uint32(char(in))),''));

md = MessageDigest.getInstance('MD5');
hash = md.digest(double(testname));
bi = BigInteger(1, hash);
out = string(bi.toString(16));
end
end