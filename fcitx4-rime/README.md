# Rime 個人輸入方案集。

一套不报错的配置，堪堪能用的词库。

## 使用方法

### Arch Linux

这样：

    sudo pacman -S fcitx-rime
    git clone https://github.com/appleshan/dotfiles.git ~/dotfiles
    cd ~/.config/fcitx
    cp ~/dotfiles/user-home/.config/fcitx/rime rime

然后注销，登入，在输入法里选上 Rime，点部署/Deploy，过一会儿（搞不好会）提示成功，就能用了。

## 已公佈

*   朙月拼音（luna-pinyin）

*   特殊字符（symbols）

    用於擴展其它輸入方案的特殊字符輸入方案。鍵入 <kbd>?</kbd> 查看縮略碼表。

    內容包括：英文字母、計數字符、特殊符號、標點符號、漢語拼音、註音符號、漢字筆畫、偏旁部首、漢字結構、日文假名、希臘字母、俄語字母、希伯來文、拉丁字母、羅馬數字、計量單位、貨币單位、數學算符、分數符號、聲調調型、時間日期、易經八卦、太玄經爻、盲文點字、漢文批註、上標下標、星號標記、指向箭頭、製表符號、組合方塊、幾何圖形、電腦界面、信號標誌、人物表情、兩性關係、音樂樂譜、天氣狀況、黃道星宮、宇宙天體、煉金符號、遊戲紙牌、棋子骰子、國家地區、空白字符。

    不考慮加入更多 Emoji 圖像相關字符。（Unicode 標準製定者甚無聊）

    可參考 [example-symbols](others/example-symbols.schema.yaml) 方案瞭解如何套用該方案於其它輸入方案。

以上方案均爲我的主要輸入方案中嵌套的方案，故其按鍵設計有些許怪異。若覺得修改不便可通過內附郵箱地址深入交流。
