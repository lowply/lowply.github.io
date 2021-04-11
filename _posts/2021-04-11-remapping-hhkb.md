---
layout: post
title: Remapping HHKB
date: 2021-04-11 13:52:32 +0900
last_modified: 2021-04-11 22:16:50 +0900
category: blog
---

I recently switched my main keyboard from [Ergodox EZ](https://ergodox-ez.com/) to [Happy Hacking Keyboard (PD-KB800BNS)](https://www.pfu.fujitsu.com/direct/hhkb/detail_pd-kb800bns.html), also known as HHKB. This is my first Electrostatic Capacitive keyboard.

I was mostly happy with Ergodox EZ over the past few years, specifically the split design and its ability to remap every single keys programmatically. But also there are some flip sides. First, due to the split design, I had to adjust _two (physical) keyboards_ positions every time I move them out to clean my desk up and that was a bit frustrating. Secondly, it's size. It's too big that it occupies my desk space. I like putting my Apple Magic Trackpad 2 in between the keyboards, but as a result the total length of the keyboard - trackpad - keyboard setup ends up to be 64cm in width. Thirdly, Ergodox EZ has too many keys. I didn't use all keys. After seeing someone I know switching to [Keyboardio Atreus](https://shop.keyboard.io/products/keyboardio-atreus), minimum and compact keyboards started to attract me.

Then I learned that PFU has updated the HHKB lineup in 2019 with the new "HYBRID Type-S" models. This made me start thinking about switching my keyboard a bit more seriously. Online reviews were all positive. I see some people even say that they can't go back to the mechanical keyboards anymore. I asked one of my tech friend who's obsessed with the electrostatic capacitive keyboards, and his opinion was like that too.

{% include img.html name="hhkb.jpg" %}

So I got it on March 29th. Unboxing was exciting. The typing sound is gorgeous. The size and weight is nice. I like the [optional replacement keycap](https://www.pfu.fujitsu.com/direct/hhkb/hhkb-option/detail_keytop-proc.html) color, this is good red. But as I tweeted, the biggest obstacle for me was that the `Fn` key to be located at the right bottom of the keyboard. I tried to get used to the keyboard's default arrow key mappings (`Fn` + `[`, `;`, `'`, `/`) but that didn't work for me at all because putting my right pinky on the `Fn` key completely breaks the home position. Maybe more practice will do in the future, but not now.

<blockquote class="twitter-tweet" data-theme="light"><p lang="ja" dir="ltr">HHKB今まで全く興味なかったのにここ最近なぜか気になり始め購入。Ergodox EZも2年使って馴染んできてたけど、セパレート故の取り回しにくさとかデカさが常にあった。アローキーはそもそもいらない派だけど右Fnが最大の壁。 <a href="https://t.co/ju2V3PySrW">pic.twitter.com/ju2V3PySrW</a></p>&mdash; lowply (@lowply) <a href="https://twitter.com/lowply/status/1376545595469352962?ref_src=twsrc%5Etfw">March 29, 2021</a></blockquote> <script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script>

After some trials and errors, I decided to override `Ctrl` + `H`,`J`,`K`,`L` to arrow keys using [Karabiner-Elements](https://karabiner-elements.pqrs.org/). To tell the truth, I'm not 100% happy with this mapping, because I used to use `Ctrl + L` a lot in my terminal and `Ctrl + K` to convert a Japanese word to Katakana forcefully.

However, there's always a workaround. Of course `Ctrl + L` can be replaced with the `clear` command in Bash. In addition, surprisingly, `Ctrl + K` can still be used to convert a Japanese word to Katakana after starting the conversion by `Space` or `Ctrl + J` then scrolling the list in reverse order by `Ctrl + K`.

Holding the `Fn` key by the left pinky and using the right hand for the `HJKL` was the mapping I used to use with Ergodox EZ.


I know [the macOS's default key bindings](https://support.apple.com/ja-jp/HT201236) such as `Ctrl` + `A`, `E`, `F`, `B`, `N`, `P` are all useful when editing texts. But these are not perfect when combined with modifier keys such as `Shift`, `Command`, `Option` because they sometimes conflict with some keyboard shortcut of the application.

For example, holding `Option` you can move the cursor by the word (like Vim's `w`). Holding `Shift` you can select the sentence. With `Command` you can jump the cursor to the beginning or the end of the sentence. This is technically different from `Ctrl + A` or `Ctrl + E` because it considers text wrapping.

To utilize these powerful editing shortcuts, I needed arrow keys.

<blockquote class="twitter-tweet"><p lang="ja" dir="ltr">HHKBのFn + アローキー、ホームポジションが大きくずれるのがどうしても気に入らないからKarabinerでCtrl + HJKLをアローキーにマップした。本来の機能が上書きされるけど仕方ない。。。Ergodoxで使っていたキーマップに近いのでまあ悪くない。</p>&mdash; lowply (@lowply) <a href="https://twitter.com/lowply/status/1380855105721757700?ref_src=twsrc%5Etfw">April 10, 2021</a></blockquote> <script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script>

I've put my custom config file in [my dotfiles repo](https://github.com/lowply/dotfiles/blob/master/symlinks/.config/karabiner/assets/complex_modifications/lowply.json), but here's an extract:

```json
{
    "description": "Control + HJKL to arrow keys",
    "manipulators": [
        {
            "type": "basic",
            "from": {
                "key_code": "h",
                "modifiers": {
                    "mandatory": [ "left_control" ],
                    "optional": [ "any" ]
                }
            },
            "to": [
                { "key_code": "left_arrow" }
            ]
        },
        {
            "from": {
                "key_code": "j",
                "modifiers": {
                    "mandatory": [ "left_control" ],
                    "optional": [ "any" ]
                }
            },
            "to": [
                { "key_code": "down_arrow" }
            ],
            "type": "basic"
        },
        {
            "from": {
                "key_code": "k",
                "modifiers": {
                    "mandatory": [ "left_control" ],
                    "optional": [ "any" ]
                }
            },
            "to": [
                { "key_code": "up_arrow" }
            ],
            "type": "basic"
        },
        {
            "from": {
                "key_code": "l",
                "modifiers": {
                    "mandatory": [ "left_control" ],
                    "optional": [ "any" ]
                }
            },
            "to": [
                { "key_code": "right_arrow" }
            ],
            "type": "basic"
        }
    ]
}
```

In addition, I made both left and right `Option` keys for IME switching. [There's the publicly available rule that makes `command` keys to be IME switching](https://ke-complex-modifications.pqrs.org/#japanese), but it conflicts when I type too fast. I made the left `Option` key to be `英数` and the right ption key to be `かな`.

```json
{
    "description": "Option to Eisuu / Kana",
    "manipulators": [
        {
            "type": "basic",
            "from": {
                "key_code": "left_option",
                "modifiers": {
                    "optional": [
                        "any"
                    ]
                }
            },
            "parameters": {
                "basic.to_if_held_down_threshold_milliseconds": 100
            },
            "to": [
                {
                    "key_code": "left_option",
                    "lazy": true
                }
            ],
            "to_if_held_down": [
                {
                    "key_code": "left_option"
                }
            ],
            "to_if_alone": [
                {
                    "key_code": "japanese_eisuu"
                }
            ]
        },
        {
            "type": "basic",
            "from": {
                "key_code": "right_option",
                "modifiers": {
                    "optional": [
                        "any"
                    ]
                }
            },
            "parameters": {
                "basic.to_if_held_down_threshold_milliseconds": 100
            },
            "to": [
                {
                    "key_code": "right_option",
                    "lazy": true
                }
            ],
            "to_if_held_down": [
                {
                    "key_code": "right_option"
                }
            ],
            "to_if_alone": [
                {
                    "key_code": "japanese_kana"
                }
            ]
        }
    ]
}
```

So far so good! The only remaining concern is the prefix conflict in [tmux](https://github.com/tmux/tmux/wiki).

<blockquote class="twitter-tweet" data-conversation="none"><p lang="ja" dir="ltr">が、tmuxのプレフィックスにCtrl + Aを使っててこれがバッティングするのはこれはこれで辛い。この機会にtmuxやめてKittyネイティブのタブとかペイン操作を覚えるかー。。。もしくはtmuxのプレフィックス変えるか。</p>&mdash; lowply (@lowply) <a href="https://twitter.com/lowply/status/1380855106728382467?ref_src=twsrc%5Etfw">April 10, 2021</a></blockquote> <script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script>

My current prefix is `Ctrl + A` and it conflicts with `Ctrl + HJKL` keymap if I hold the left `Control` key too long. I'm now learning Kitty (my main terminal client) 's [native keyboard shortcuts](https://sw.kovidgoyal.net/kitty/#tabs-and-windows) so I can say goodbye to my 10 years friend, tmux. My keyboard journey has just started...
