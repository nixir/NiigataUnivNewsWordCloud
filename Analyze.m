% Analyze Japanese Text Data
% https://jp.mathworks.com/help/textanalytics/ug/analyze-japanese-text.html

close all;
clear;
clc;

%% Analyze Japanese Text Data

url = "https://www.niigata-u.ac.jp/news/2021/92693/";
options = weboptions('CharacterEncoding','UTF-8');
code = webread(url,options);
%% 
% View the first few lines of the HTML code.

%extractBefore(code,'</title>')
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
todaydatetime = string(datetime('today','Format','yyyy-MM-dd'));

pagefilename = todaydatetime + '-' + htmltitletext + '.md';
imagefilename = todaydatetime + '-' + htmltitletext + '.png';

frontmatter = ["---" + newline +...
'layout: post'+ newline +...
'title:  "Welcome to Jekyll!"'+ newline +...
'---'];

pagecontent = [frontmatter + newline +...
    "TESTMATLAB"];

fileID = fopen("./docs/_posts/" + pagefilename,'w');
fprintf(fileID,'%s',pagecontent);
fclose(fileID);

saveas(fig,"./docs/_posts/" + imagefilename)
% _Copyright 2018 The MathWorks, Inc._


