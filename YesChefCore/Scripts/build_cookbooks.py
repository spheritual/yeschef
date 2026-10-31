#!/usr/bin/env python3

#builds Sources/YesChefCore/Resources/cookbooks.json from Project Gutenberg plain-text cookbooks
# usage: build_cookbooks.py DIR, where DIR holds pg<id>.txt files downloaded from
# https://www.gutenberg.org/cache/epub/<id>/pg<id>.txt
# every book here is on Gutenberg's Cookbooks and Cooking shelf and public domain in the US
import json,re,sys
from pathlib import Path

BOOKS={
    6912:("School and Home Cooking","Carlotta C. Greer"),
    34822:("The Century Cook Book","Mary Ronald"),
    6745:("Miss Parloa's New Cook Book","Maria Parloa"),
    24407:("The Italian Cook Book","Maria Gentile"),
    13887:("Dr. Allinson's Cookery Book","T. R. Allinson"),
    12350:("The International Jewish Cook Book","Florence Kreisler Greenbaum"),
}
OUT=Path(__file__).resolve().parent.parent/"Sources/YesChefCore/Resources/cookbooks.json"
COOKING=re.compile(r"\b(cups?|teaspoons?|tablespoons?|ounces?|pounds?|oven|bake|boil|simmer|stir|minutes|salt|butter|flour|fry|roast)\b",re.I)

def body(text):
    #only the book itself, without Gutenberg's license header and footer
    start=re.search(r"\*\*\* ?START OF (THE|THIS) PROJECT GUTENBERG[^\n]*",text)
    end=re.search(r"\*\*\* ?END OF (THE|THIS) PROJECT GUTENBERG",text)
    return text[start.end() if start else 0:end.start() if end else len(text)]

def clean(block):
    block=re.sub(r"\[Illustration[^\]]*\]","",block)
    #the Century Cook Book marks headings as =Name=, and other books italicize with _name_
    block=block.replace("_","").replace("=","")
    return re.sub(r"\s+"," ",block).strip()

def is_heading(block):
    line=block.strip()
    return "\n" not in line and 3<=len(line)<=60 and not line.endswith((".",",",";",":")) and any(c.isalpha() for c in line) and (line.isupper() or line.istitle())

def passages(book_id,text):
    out=[]
    heading,parts=None,[]
    def flush():
        joined=" ".join(parts)
        if heading and len(joined)>=150 and len(COOKING.findall(joined))>=2:
            out.append({"book":book_id,"heading":heading.title() if heading.isupper() else heading,"text":joined[:1200]})
    for raw in re.split(r"\n\s*\n",body(text).replace("\r\n","\n")):
        if not raw.strip():
            continue
        if is_heading(raw):
            flush()
            heading,parts=clean(raw),[]
            continue
        parts.append(clean(raw))
        if sum(len(p) for p in parts)>1100:
            flush()
            parts=[]
    flush()
    return out

def main(folder):
    sources=[{"id":i,"title":t,"author":a,"url":f"https://www.gutenberg.org/ebooks/{i}"} for i,(t,a) in BOOKS.items()]
    found=[]
    for book_id in BOOKS:
        found+=passages(book_id,(Path(folder)/f"pg{book_id}.txt").read_text(encoding="utf-8",errors="replace"))
    OUT.parent.mkdir(parents=True,exist_ok=True)
    OUT.write_text(json.dumps({"sources":sources,"passages":found},ensure_ascii=True,separators=(",",":")),encoding="ascii")
    counts={b:sum(1 for p in found if p["book"]==b) for b in BOOKS}
    print(f"wrote {len(found)} passages to {OUT} ({OUT.stat().st_size} bytes); per book {counts}")

if __name__=="__main__":
    main(sys.argv[1])
