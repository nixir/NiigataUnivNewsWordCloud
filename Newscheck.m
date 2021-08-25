close all;
clear;
clc;


%% 

url = "https://www.niigata-u.ac.jp/news/";
options = weboptions('CharacterEncoding','UTF-8');
code = webread(url,options);

tree = htmlTree(code);
htmlnews = (findElement(tree,'a'));
htmlnewslink = getAttribute(htmlnews,"href");
pat = digitsPattern(4);
htmlnewslink = htmlnewslink(contains(htmlnewslink,pat));
htmlnewslink = htmlnewslink(contains(htmlnewslink,"www.niigata-u.ac.jp"));%Avoid subdomains.


htmlnewslink = string(htmlnewslink);

for i = 1:length(htmlnewslink)
    AnalyzeArticle(htmlnewslink(i));
end