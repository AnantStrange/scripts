#!/usr/bin/python3

import unicodedata
import os

fonts = []

for root,dirs,files in os.walk("/usr/share/fonts/"):
    for file in files:
       if file.endswith(".ttf"): fonts.append(os.path.join(root,file))


from fontTools.ttLib import TTFont

def char_in_font(unicode_char, font):
    for cmap in font['cmap'].tables:
        if cmap.isUnicode():
            if ord(unicode_char) in cmap.cmap:
                return True
    return False

def test(char):
    for fontpath in fonts:
        font = TTFont(fontpath)   # specify the path to the font in question
        if char_in_font(char, font):
            print(char + " "+ unicodedata.name(char) + " in " + fontpath) 

test(u"😺")
test(u"🐈")
test(u"")



