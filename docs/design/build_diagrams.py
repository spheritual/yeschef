#!/usr/bin/env python3

#builds docs/design/yeschef.drawio, one tab per diagram, from the layouts in this file
# run it again after a design change instead of hand-editing the xml
# --preview DIR also writes a rough svg of each tab, which is only for checking the layout
import html,re,sys,xml.etree.ElementTree as ET
from pathlib import Path

OUT=Path(__file__).with_name("yeschef.drawio")

#the app's own palette from design/tokens.json
INK="#263B2E"
GREEN="#386347"
CREAM="#F8F5EC"
CARD="#FFFEF8"
SAGE="#E7ECCD"
MUTED="#73796B"
TOMATO="#BC5039"

BASE=f"html=1;whiteSpace=wrap;fontColor={INK};strokeColor={GREEN};fontSize=13;"
STYLES={
    "title":"text;html=1;align=left;verticalAlign=top;fontSize=22;fontStyle=1;fontColor=#263B2E;",
    "caption":"text;html=1;align=left;verticalAlign=top;whiteSpace=wrap;fontSize=13;fontColor=#73796B;",
    "box":BASE+f"rounded=1;arcSize=12;fillColor={CARD};",
    "system":f"html=1;whiteSpace=wrap;rounded=1;arcSize=12;fillColor={GREEN};fontColor=#FFFFFF;strokeColor={INK};fontSize=14;",
    "external":BASE+f"rounded=1;arcSize=12;fillColor={SAGE};",
    "later":BASE+f"rounded=1;arcSize=12;fillColor=#FFFFFF;dashed=1;fontColor={MUTED};strokeColor={MUTED};",
    "group":BASE+f"rounded=1;arcSize=4;fillColor={CREAM};verticalAlign=top;align=left;spacingLeft=12;spacingTop=6;fontStyle=1;fontSize=15;",
    "subgroup":BASE+"rounded=1;arcSize=6;fillColor=#FFFFFF;verticalAlign=top;align=left;spacingLeft=10;spacingTop=4;fontStyle=1;dashed=1;",
    "actor":f"shape=umlActor;verticalLabelPosition=bottom;verticalAlign=top;html=1;outlineConnect=0;fillColor={CARD};strokeColor={INK};fontColor={INK};fontSize=13;",
    "usecase":BASE+f"ellipse;fillColor={CARD};",
    "boundary":BASE+"rounded=0;fillColor=none;verticalAlign=top;fontStyle=1;fontSize=15;",
    "note":f"shape=note;size=14;html=1;whiteSpace=wrap;align=left;verticalAlign=top;spacingLeft=8;spacingTop=4;fillColor=#FFF7DD;strokeColor=#C9A43A;fontColor={INK};fontSize=12;",
    "class":f"html=1;whiteSpace=wrap;verticalAlign=top;align=left;overflow=fill;fontSize=12;fillColor={CARD};strokeColor={GREEN};fontColor={INK};",
    "lifeline":f"shape=umlLifeline;perimeter=lifelinePerimeter;html=1;whiteSpace=wrap;container=1;collapsible=0;recursiveResize=0;outlineConnect=0;size=46;fillColor={CARD};strokeColor={GREEN};fontColor={INK};fontSize=12;",
    "frame":f"shape=umlFrame;html=1;whiteSpace=wrap;width=150;height=24;fillColor=none;strokeColor={MUTED};fontColor={INK};fontSize=11;align=left;spacingLeft=6;",
    "state":BASE+f"rounded=1;arcSize=40;fillColor={CARD};",
    "start":f"ellipse;html=1;fillColor={INK};strokeColor={INK};",
    "end":f"ellipse;html=1;fillColor={INK};strokeColor={CARD};strokeWidth=4;",
    "action":BASE+f"rounded=1;arcSize=30;fillColor={CARD};",
    "decision":BASE+f"rhombus;fillColor={SAGE};fontSize=12;",
    "node":BASE+f"shape=cube;size=12;darkOpacity=0.05;fillColor={CREAM};verticalAlign=top;align=left;spacingLeft=10;spacingTop=8;fontStyle=1;",
    "artifact":BASE+f"shape=note;size=12;fillColor={CARD};fontSize=12;",
    "phone":f"html=1;whiteSpace=wrap;rounded=1;arcSize=6;fillColor=#FFFFFF;strokeColor=#555555;strokeWidth=2;verticalAlign=bottom;fontSize=12;fontStyle=1;fontColor=#333333;",
    "wire":"html=1;whiteSpace=wrap;rounded=1;arcSize=10;fillColor=#E6E6E6;strokeColor=#999999;fontColor=#333333;fontSize=11;",
    "wiredark":"html=1;whiteSpace=wrap;rounded=1;arcSize=10;fillColor=#BDBDBD;strokeColor=#888888;fontColor=#222222;fontSize=11;",
    "wirecircle":"ellipse;html=1;whiteSpace=wrap;fillColor=#BDBDBD;strokeColor=#888888;fontColor=#222222;fontSize=10;",
    "mono":f"text;html=1;align=left;verticalAlign=top;whiteSpace=nowrap;fontFamily=Courier New;fontSize=13;fontColor={INK};spacingLeft=10;spacingTop=8;fillColor={CARD};strokeColor={GREEN};rounded=1;arcSize=2;",
}
EDGES={
    "arrow":f"html=1;endArrow=block;endFill=1;strokeColor={INK};fontColor={INK};fontSize=11;labelBackgroundColor={CREAM};",
    "line":f"html=1;endArrow=none;strokeColor={INK};",
    "dashed":f"html=1;endArrow=open;dashed=1;strokeColor={MUTED};fontColor={MUTED};fontSize=11;labelBackgroundColor={CREAM};",
    "include":f"html=1;endArrow=open;dashed=1;strokeColor={INK};fontColor={INK};fontSize=11;labelBackgroundColor=#FFFFFF;",
    "realize":f"html=1;endArrow=block;endFill=0;dashed=1;strokeColor={INK};",
    "compose":f"html=1;startArrow=diamondThin;startFill=1;startSize=14;endArrow=open;strokeColor={INK};fontColor={INK};fontSize=11;labelBackgroundColor=#FFFFFF;",
    "uses":f"html=1;endArrow=open;dashed=1;strokeColor={INK};fontColor={INK};fontSize=11;labelBackgroundColor=#FFFFFF;",
    "message":f"html=1;endArrow=block;endFill=1;strokeColor={INK};fontColor={INK};fontSize=11;labelBackgroundColor=#FFFFFF;verticalAlign=bottom;",
    "reply":f"html=1;endArrow=open;dashed=1;strokeColor={MUTED};fontColor={MUTED};fontSize=11;labelBackgroundColor=#FFFFFF;verticalAlign=bottom;",
    "flow":f"html=1;endArrow=block;endFill=1;strokeColor={INK};fontColor={INK};fontSize=11;labelBackgroundColor=#FFFFFF;edgeStyle=orthogonalEdgeStyle;rounded=1;",
}

class Page:
    def __init__(self,name,width,height):
        self.name,self.width,self.height=name,width,height
        self.cells=[]
        self.next_id=2

    def _id(self):
        self.next_id+=1
        return f"c{self.next_id}"

    def box(self,x,y,w,h,text,kind="box",parent="1"):
        cid=self._id()
        self.cells.append(dict(id=cid,kind=kind,vertex=True,x=x,y=y,w=w,h=h,text=text,parent=parent,style=STYLES[kind]))
        return cid

    def edge(self,src,dst,text="",kind="arrow",extra=""):
        cid=self._id()
        self.cells.append(dict(id=cid,kind=kind,edge=True,src=src,dst=dst,text=text,style=EDGES[kind]+extra))
        return cid

    def msg(self,x1,x2,y,text,kind="message"):
        #free-floating sequence message between two lifeline x positions
        cid=self._id()
        self.cells.append(dict(id=cid,kind=kind,edge=True,points=(x1,y,x2,y),text=text,style=EDGES[kind]))
        return cid

    def header(self,title,caption):
        self.box(40,20,self.width-80,36,title,"title")
        self.box(40,60,self.width-80,44,caption,"caption")

def uml(name,width,fields=(),methods=(),stereotype=""):
    top=f"<i>&laquo;{stereotype}&raquo;</i><br>" if stereotype else ""
    parts=[f'<p style="margin:4px 0;text-align:center;">{top}<b>{html.escape(name)}</b></p>']
    #at 12px a line holds about one character per 6.5 points, and wrapped lines need room too
    per_line=max(int((width-12)/6.5),10)
    rows=lambda group:sum(-(-len(line)//per_line) for line in group)
    for group in (fields,methods):
        if group:
            parts.append('<hr size="1">')
            parts.append('<p style="margin:0 6px;">'+"<br>".join(html.escape(line) for line in group)+"</p>")
    height=34+(18 if stereotype else 0)+sum(17*rows(g)+12 for g in (fields,methods) if g)
    return "".join(parts),height

def classbox(page,x,y,w,name,fields=(),methods=(),stereotype=""):
    label,h=uml(name,w,fields,methods,stereotype)
    return page.box(x,y,w,h,label,"class")

pages=[]

#1 system context
p=Page("1 System context",1500,760)
p.header("1. System context","Who and what yeschef! talks to. Solid lines are in the demo; dashed boxes are planned for after the hackathon. Everything not shown stays on the phone, and the demo keeps its data in memory only.")
cook=p.box(70,260,50,90,"Home cook","actor")
app=p.box(330,230,330,150,"<b>yeschef!</b><br>iPhone app (Swift and SwiftUI)<br><br>Plans the week's dinners, teaches each recipe step by step through Basil the chef, and learns the household's tastes.","system")
gemini=p.box(900,140,360,120,"<b>Gemini API</b> (Google)<br>Serves Gemma 4, gemma-4-26b-a4b-it, an open-weight model under Apache 2.0","external")
ios=p.box(900,320,360,130,"<b>iOS frameworks on the phone</b><br>Speech for voice questions, AVSpeechSynthesizer for Basil's voice, PhotosUI for recipe photos, UserNotifications for timers","external")
cal=p.box(330,520,330,80,"Calendar (EventKit) and Apple Health<br>planned","later")
shops=p.box(900,520,360,80,"Grocery store deals and pickup orders<br>planned, APIs unverified","later")
p.edge(cook,app,"talks, taps, cooks and rates")
p.edge(app,gemini,"HTTPS: plans, recipes, photo reads, answers")
p.edge(app,ios,"on-device calls")
books=p.box(40,520,250,100,"<b>Six public-domain cookbooks</b><br>from Project Gutenberg, bundled in the app and searched on the phone","external")
p.edge(app,books,"grounds Gemma's prompts")
p.edge(app,cal,"","dashed")
p.edge(app,shops,"","dashed")
pages.append(p)

#2 components
p=Page("2 Components",1720,900)
p.header("2. Containers and components","The app target holds the screens and anything that needs an Apple-only framework. YesChefCore holds the Gemma calls and the learning, has no UI, and builds and tests on the Mac and on Linux. Screens never call Gemma themselves; they go through AppModel.")
g1=p.box(40,120,780,720,"YesChef app target (SwiftUI, builds in Xcode)","group")
views=p.box(70,170,720,40,"<b>Screens</b>","subgroup")
v_main=p.box(80,220,220,110,"<b>MainScreen</b><br>BasilView and BasilStage, SubtitleBar, BurgerButton and BurgerMenu, LearningCard")
v_pages=p.box(320,220,220,110,"<b>MenuPages</b><br>This week (DayCard), RecipesPage, ShoppingListPage, HouseholdPage, SettingsPage")
v_cook=p.box(560,220,220,110,"<b>CookModeView</b><br>one step at a time, step timers with notifications, RatingSheet at the end")
v_chat=p.box(80,350,220,70,"<b>ChatView</b><br>full text conversation")
v_import=p.box(320,350,220,70,"<b>ImportView</b><br>pick a recipe photo")
v_voice=p.box(560,350,220,70,"<b>Voice</b><br>MicButton, BasilVoice")
model=p.box(200,480,460,130,"<b>AppModel</b> (@Observable, shared state)<br>household, busy days, plan, recipe, mood, subtitle, messages, one PreferenceModel per member<br>planWeek(), open(), ask(), importRecipe(), record(), retry()")
theme=p.box(80,680,220,110,"<b>Theme</b> and <b>AppSecrets</b><br>colors and fonts from design/tokens.json; the Gemini key from Config/Secrets.xcconfig")
assets=p.box(560,680,220,110,"<b>Assets</b><br>Basil and the pan with steam as SVG, from design/assets")
g2=p.box(880,120,560,720,"YesChefCore Swift package (no UI)","group")
gem=p.box(910,170,500,40,"<b>Gemma</b>","subgroup")
c_planner=p.box(920,220,230,120,"<b>MealPlanner</b><br>planWeek, recipe(for:), recipeFromImage, askChef")
c_client=p.box(1170,220,230,120,"<b>GemmaClient</b><br>REST call to generateContent, key in a header, thinking off")
c_prompts=p.box(920,355,230,70,"<b>Prompts</b>, <b>JSONReply</b><br>Basil's voice and the JSON shapes")
c_sample=p.box(1170,355,230,70,"<b>SampleData</b><br>offline plan for previews")
lrn=p.box(910,460,500,40,"<b>Learning</b>","subgroup")
c_rules=p.box(920,510,230,100,"<b>HardRules</b><br>drops allergens and dislikes before ranking")
c_rank=p.box(1170,510,230,100,"<b>Recommender</b><br>Thompson sampling, household average")
c_pref=p.box(920,640,230,120,"<b>PreferenceModel</b><br>Bayesian linear model per member, decay on old feedback")
c_enc=p.box(1170,640,230,120,"<b>FeatureEncoder</b>, <b>FeedbackSignal</b><br>15 recipe and day features; ratings to rewards")
c_books=p.box(920,772,480,58,"<b>Cookbook</b>: BM25 search over 3,268 passages from six Gutenberg cookbooks","external")
api=p.box(1490,240,200,100,"<b>Gemini API</b><br>Gemma 4","external")
p.edge(v_main,model,"","uses")
p.edge(v_cook,model,"","uses")
p.edge(v_chat,model,"","uses")
p.edge(v_import,model,"","uses")
p.edge(v_voice,model,"transcribed question","uses")
p.edge(model,c_planner,"plan, recipe, ask, import")
p.edge(model,c_pref,"record feedback")
p.edge(c_planner,c_client,"")
p.edge(c_planner,c_rules,"")
p.edge(c_planner,c_rank,"")
p.edge(c_rank,c_pref,"")
p.edge(c_client,api,"HTTPS")
p.edge(c_planner,c_books,"","uses")
pages.append(p)

#3 use cases
p=Page("3 Use cases",1500,900)
p.header("3. Use cases","What a home cook can do in the demo, and which of those call Gemma 4. The dashed include lines mark steps every plan goes through. Planned features are listed in the note.")
cook=p.box(60,330,50,90,"Home cook","actor")
gemma=p.box(1360,330,50,90,"Gemma 4","actor")
p.box(220,120,1060,700,"yeschef!","boundary")
uc={}
left=["Set up household, allergies and likes","Plan my week","Swap a dinner","See the shopping list","Import a recipe from a photo"]
right=["Open a recipe","Cook step by step with timers","Ask Basil by voice or text","Rate a dinner","See what Basil learned","Mute Basil's voice"]
for i,name in enumerate(left):
    uc[name]=p.box(290,170+i*120,250,70,name,"usecase")
for i,name in enumerate(right):
    uc[name]=p.box(760,160+i*105,250,70,name,"usecase")
inc1=p.box(560,700,200,60,"Remove allergens and dislikes","usecase")
inc2=p.box(1040,700,200,60,"Rank by learned taste","usecase")
for name in uc:
    p.edge(cook,uc[name],"","line")
for name in ["Plan my week","Open a recipe","Ask Basil by voice or text","Import a recipe from a photo"]:
    p.edge(gemma,uc[name],"","line")
p.edge(uc["Plan my week"],inc1,"&laquo;include&raquo;","include")
p.edge(uc["Plan my week"],inc2,"&laquo;include&raquo;","include")
p.edge(uc["Rate a dinner"],inc2,"feeds","include")
p.box(1060,140,200,190,"<b>Planned</b><br>calendar-aware days, store deals and pickup orders, a budget, health goals, restaurant check-ins, points and streaks to dress up Basil","note")
pages.append(p)

#4 classes in YesChefCore
p=Page("4 Classes: YesChefCore",1760,1180)
p.header("4. Class diagram: YesChefCore","The types the app builds on. All of them are value types except GemmaClient's network call, which keeps them testable on Linux. Filled diamonds mean one type holds the other; dashed arrows mean one uses the other.")
lm=classbox(p,40,130,250,"LanguageModel",(),("+ generate(prompt, system, image, mimeType) async throws: String",),"protocol")
gc=classbox(p,40,320,250,"GemmaClient",("+ model: String = gemma-4-26b-a4b-it","+ thinking: Bool = false","- apiKey: String"),("+ generate(...) async throws: String",))
mp=classbox(p,360,130,300,"MealPlanner",("- model: LanguageModel",),("+ planWeek(household, days, busyDays, learning) : WeekPlan","+ recipe(for: idea, household, servings) : RecipeDetail","+ recipeFromImage(data, mimeType, household) : RecipeDetail","+ askChef(question, step, recipe) : String"))
pr=classbox(p,360,400,300,"Prompts",(),("chef, week(...), recipe(...), fromImage, question(...), retry",),"enum")
ge=classbox(p,40,520,250,"GemmaError",("badModelName, http(status, message)","emptyReply, notJSON","noSafeIdeas, unsafeRecipe(ingredient)"),(),"enum")
hh=classbox(p,730,130,260,"Household",("+ members: [Member]","+ weeklyBudget: Double?"),("+ bannedTerms: Set<String>",))
mb=classbox(p,730,340,260,"Household.Member",("+ name, cookingSkill: String","+ likes, avoid: [String]","+ diet: String?"),())
wp=classbox(p,1060,130,260,"WeekPlan",("+ days: [Day]",),("+ shoppingList: [String]",))
wd=classbox(p,1060,320,260,"WeekPlan.Day",("+ day: String","+ isBusy: Bool","+ pick: DinnerIdea","+ alternatives: [DinnerIdea]"),())
di=classbox(p,1060,560,260,"DinnerIdea",("+ title, summary: String","+ features: RecipeFeatures","+ ingredients: [String]"),())
rd=classbox(p,1400,130,320,"RecipeDetail",("+ title: String","+ servings, minutes: Int","+ ingredients: [Ingredient]","+ steps: [Step]"),())
ri=classbox(p,1400,370,320,"RecipeDetail.Ingredient",("+ name, amount, unit: String",),())
rs=classbox(p,1400,500,320,"RecipeDetail.Step",("+ instruction: String","+ technique: String","+ timerSeconds: Int?"),())
rf=classbox(p,1060,800,260,"RecipeFeatures",("+ protein: Protein","+ flavours: Set<Flavour>","+ minutes: Int","+ difficulty: Difficulty","+ costPerServing: Double"),())
en=classbox(p,1400,800,320,"Protein, Flavour, Difficulty",("chicken, beef, pork, fish, vegetarian","spicy, sweet, savory, fresh","easy, medium, hard"),(),"enum")
fe=classbox(p,730,800,260,"FeatureEncoder",("+ labels: [String] (15)",),("+ encode(recipe, on: DayContext) : [Double]",),"enum")
dc=classbox(p,730,1010,260,"DayContext",("+ isBusy: Bool",),())
pm=classbox(p,360,800,300,"PreferenceModel",("+ dimension, prior, decay, spread","- precision: [Double] (15 x 15)","- target: [Double]"),("+ record(signal, for: features)","+ expectedScore(features) : Double","+ uncertainty(features) : Double","+ weights: [Double]"))
fs=classbox(p,360,1060,300,"FeedbackSignal",("rated(stars), cooked, swapped, skipped",),("+ reward: Double (0 to 1)",),"enum")
rc=classbox(p,40,800,250,"Recommender",(),("+ rank(items, features, models, using: rng) : [Ranked]",),"enum")
hr=classbox(p,40,960,250,"HardRules",(),("+ excluding(items, ingredients, banned)","+ mentions(ingredient, term) : Bool"),"enum")
p.edge(gc,lm,"","realize")
p.edge(mp,lm,"model","compose")
p.edge(mp,pr,"","uses")
p.edge(mp,wp,"returns","uses")
p.edge(mp,rd,"returns","uses")
p.edge(mp,hr,"","uses")
p.edge(mp,rc,"","uses")
p.edge(hh,mb,"members","compose")
p.edge(wp,wd,"days","compose")
p.edge(wd,di,"pick, alternatives","compose")
p.edge(di,rf,"features","compose")
p.edge(rd,ri,"","compose")
p.edge(ri,rs,"","line",";strokeColor=none;")
p.edge(rf,en,"","uses")
p.edge(fe,rf,"","uses")
p.edge(fe,dc,"","uses")
p.edge(rc,pm,"models","uses")
p.edge(pm,fs,"","uses")
pages.append(p)

#5 classes in the app
p=Page("5 Classes: app",1500,960)
p.header("5. Class diagram: the app target","AppModel is the one shared object. Every screen reads it from the SwiftUI environment and calls its methods, and it is the only place that talks to YesChefCore.")
am=classbox(p,520,130,420,"AppModel",("+ household: Household","+ busyDays: Set<String>","+ plan: WeekPlan","+ recipe: RecipeDetail?","+ recipeIdea: DinnerIdea?","+ mood: BasilMood","+ subtitle: String","+ messages: [ChatMessage]","+ learning: [String: PreferenceModel]","- planner: MealPlanner?"),("+ planWeek() async","+ open(idea) async","+ ask(question, step) async","+ importRecipe(from: image, mimeType) async","+ record(signal, for: idea, onBusyDay)","+ retry() async"),"Observable")
mood=classbox(p,1040,130,220,"BasilMood",("idle, listening, cooking","talking, confused"),(),"enum")
cm=classbox(p,1040,290,220,"ChatMessage",("+ speaker: user or basil","+ text: String"),())
md=classbox(p,1040,440,220,"MenuDestination",("thisWeek, recipes, shopping","household, importRecipe, settings"),("+ layer: the burger ingredient",),"enum")
sec=classbox(p,1040,630,220,"AppSecrets",(),("+ geminiAPIKey: String?",),"enum")
mp2=p.box(520,720,200,70,"<b>MealPlanner</b><br>from YesChefCore","external")
pm2=p.box(740,720,200,70,"<b>PreferenceModel</b><br>from YesChefCore","external")
vs=[]
for i,(name,desc) in enumerate([("MainScreen","Basil's stage, subtitle bar, burger, output, chat bubble"),("BurgerMenu","the six ingredient layers"),("MenuPages","week, recipes, shopping, household, settings"),("CookModeView","steps, timers, RatingSheet"),("ChatView","text conversation"),("ImportView","photo picker"),("LearningCard","what Basil learned, as bars"),("BasilVoice, MicButton","speak replies, hear questions")]):
    vs.append(p.box(60,130+i*95,360,75,f"<b>{name}</b><br>{desc}"))
for v in vs:
    p.edge(v,am,"","uses")
p.edge(am,mood,"","compose")
p.edge(am,cm,"","compose")
p.edge(am,mp2,"","compose")
p.edge(am,pm2,"one per member","compose")
p.edge(am,sec,"key","uses")
pages.append(p)

def lifelines(page,names,top=130,height=820,gap=190,x0=60,w=150):
    xs={}
    for i,name in enumerate(names):
        x=x0+i*gap
        page.box(x,top,w,height,name,"lifeline")
        xs[name]=x+w/2
    return xs

#6 sequence: plan my week
p=Page("6 Sequence: plan my week",1640,1010)
p.header("6. Sequence: planning the week","What happens between tapping Plan my week and seeing the plan. Solid arrows are calls and dashed arrows are replies. Basil does his cooking animation for the whole wait.")
x=lifelines(p,["Home cook","MainScreen","AppModel","MealPlanner","GemmaClient","Gemini API","HardRules","Recommender"],height=770)
y=200
for a,b,t,k in [("Home cook","MainScreen","taps Plan my week","message"),("MainScreen","AppModel","planWeek()","message"),("AppModel","MainScreen","mood = cooking","reply"),("AppModel","MealPlanner","planWeek(household, busyDays, learning)","message"),("MealPlanner","GemmaClient","generate(week prompt)","message"),("GemmaClient","Gemini API","POST generateContent, thinking minimal","message"),("Gemini API","GemmaClient","3 dinner ideas per day as JSON","reply"),("GemmaClient","MealPlanner","reply text","reply"),("MealPlanner","HardRules","excluding(ideas, banned terms)","message"),("HardRules","MealPlanner","safe ideas","reply"),("MealPlanner","Recommender","rank(safe ideas, members' models)","message"),("Recommender","MealPlanner","ranked ideas","reply"),("MealPlanner","AppModel","WeekPlan: a pick and swaps per day","reply"),("AppModel","MainScreen","plan, mood = talking, subtitle","reply"),("MainScreen","Home cook","Basil says the week is ready","reply")]:
    p.msg(x[a],x[b],y,t,k)
    y+=48
#messages 5 to 8 (y 392 to 536) are the Gemma round trip that gets one retry
p.box(x["MealPlanner"]-85,370,x["Gemini API"]-x["MealPlanner"]+170,185,"alt: reply isn't JSON, ask once more","frame")
p.box(40,915,760,70,"If the reply still isn't JSON after one retry, or no idea is safe, AppModel sets mood = confused and offers a retry.","note")
p.box(820,915,780,70,"Before step 5, MealPlanner searches the bundled Gutenberg cookbooks for the household's tastes, drops passages that name a banned ingredient, and puts the best six in the prompt with their books. Gemma names the book in each idea it based on one.","note")
pages.append(p)

#7 sequence: cook, ask and rate
p=Page("7 Sequence: cook, ask, rate",1460,1130)
p.header("7. Sequence: cooking a recipe, asking Basil and rating it","Opening a recipe fetches the full steps, cooking runs one step at a time, a voice question goes through Gemma, and the rating at the end updates every member's preference model.")
x=lifelines(p,["Home cook","CookModeView","AppModel","BasilVoice","MealPlanner","Gemini API","PreferenceModel"],height=950)
y=200
for a,b,t,k in [("Home cook","AppModel","opens a dinner: open(idea)","message"),("AppModel","MealPlanner","recipe(for: idea, household)","message"),("MealPlanner","Gemini API","recipe prompt","message"),("Gemini API","MealPlanner","steps with technique notes","reply"),("MealPlanner","AppModel","RecipeDetail (allergen-checked)","reply"),("Home cook","CookModeView","Start cooking","message"),("CookModeView","Home cook","step, why it matters, timer","reply"),("Home cook","BasilVoice","asks by voice","message"),("BasilVoice","AppModel","ask(question, step)","message"),("AppModel","MealPlanner","askChef(question, step, recipe)","message"),("MealPlanner","Gemini API","question prompt","message"),("Gemini API","MealPlanner","short answer","reply"),("MealPlanner","AppModel","answer","reply"),("AppModel","BasilVoice","speak(answer)","message"),("BasilVoice","Home cook","Basil answers out loud","reply"),("Home cook","CookModeView","Done, 5 stars","message"),("CookModeView","AppModel","record(.rated(stars: 5), for: idea)","message"),("AppModel","PreferenceModel","record(signal, features) per member","message")]:
    p.msg(x[a],x[b],y,t,k)
    y+=48
pages.append(p)

#8 state: Basil's moods
p=Page("8 State: Basil's moods",1300,760)
p.header("8. State machine: Basil's moods","Basil's mood drives his animation and the subtitle bar. Every Gemma call goes through cooking, and every answer ends back at idle.")
s0=p.box(80,330,30,30,"","start")
idle=p.box(200,310,160,70,"<b>Idle</b><br>breathing loop","state")
listen=p.box(480,160,180,70,"<b>Listening</b><br>mic open","state")
cooking=p.box(780,310,180,70,"<b>Cooking</b><br>pan with steam","state")
talk=p.box(480,500,180,70,"<b>Talking</b><br>speaks the subtitle","state")
conf=p.box(1040,500,180,70,"<b>Confused</b><br>tap to retry","state")
p.edge(s0,idle,"")
p.edge(idle,listen,"taps the mic")
p.edge(listen,cooking,"question sent")
p.edge(idle,cooking,"plan, open or import")
p.edge(cooking,talk,"Gemma replied")
p.edge(cooking,conf,"call failed or timed out")
p.edge(conf,cooking,"retry")
p.edge(talk,idle,"done speaking (2 to 12 s)")
pages.append(p)

#9 activity: the learning loop
p=Page("9 Activity: how Basil learns",1500,1100)
p.header("9. Activity diagram: how Basil learns","The feedback loop from .plans/feedback-learning-spec.md. Allergy rules always run before the model, and every rating, cook, swap or skip changes the next plan.")
a0=p.box(110,130,30,30,"","start")
a1=p.box(40,200,170,70,"Gemma suggests 3 dinners per day, grounded in cookbook passages","action")
a2=p.box(40,310,170,70,"Hard rules remove allergens and dislikes","action")
d1=p.box(45,420,160,100,"Any safe idea left?","decision")
a3=p.box(300,435,170,70,"Drop the day, or Basil asks again","action")
a4=p.box(40,570,170,70,"Encode 15 features with the day's context","action")
a5=p.box(40,680,170,80,"Each member's model draws weights; scores are averaged","action")
a6=p.box(40,800,170,70,"Top idea is the pick; the rest are swaps","action")
a7=p.box(320,800,170,70,"The cook sees the plan","action")
d2=p.box(560,785,160,100,"What happens?","decision")
r1=p.box(800,640,170,60,"Rated 1 to 5 stars: reward 0 to 1","action")
r2=p.box(800,730,170,60,"Cooked: reward 0.8","action")
r3=p.box(800,820,170,60,"Skipped: reward 0.3","action")
r4=p.box(800,910,170,60,"Swapped out: reward 0.1","action")
a8=p.box(1060,760,190,90,"Each member's model updates, older feedback decays by 0.97","action")
a9=p.box(1060,560,190,80,"Next plan uses the updated models","action")
p.edge(a0,a1,"","flow")
p.edge(a1,a2,"","flow")
p.edge(a2,d1,"","flow")
p.edge(d1,a3,"no","flow")
p.edge(d1,a4,"yes","flow")
p.edge(a4,a5,"","flow")
p.edge(a5,a6,"","flow")
p.edge(a6,a7,"","flow")
p.edge(a7,d2,"","flow")
for r in (r1,r2,r3,r4):
    p.edge(d2,r,"","flow")
    p.edge(r,a8,"","flow")
p.edge(a8,a9,"","flow")
p.edge(a9,a1,"next week","flow")
pages.append(p)

#10 deployment
p=Page("10 Deployment",1600,900)
p.header("10. Deployment","Where each piece runs during the hackathon. The Gemini key lives only in the gitignored Config/Secrets.xcconfig on the Mac and in the laptop's keyring; it never goes in the repo.")
n_phone=p.box(40,140,460,380,"iPhone or iOS simulator (iOS 17 or later)","node")
p.box(70,200,400,60,"YesChef.app (SwiftUI)","artifact")
p.box(70,280,400,60,"YesChefCore (linked Swift package)","artifact")
p.box(70,360,400,60,"Basil SVG assets, Theme","artifact")
p.box(70,440,400,60,"GEMINI_API_KEY from Info.plist, set by Secrets.xcconfig","artifact")
n_google=p.box(620,140,380,220,"Google Cloud","node")
p.box(650,200,320,70,"Gemini API: generativelanguage.googleapis.com","artifact")
p.box(650,280,320,60,"Gemma 4 (gemma-4-26b-a4b-it)","artifact")
n_mac=p.box(40,600,460,220,"MacBook (Davis)","node")
p.box(70,660,400,60,"Xcode: builds YesChef.app, runs the simulator","artifact")
p.box(70,740,400,60,"Config/Secrets.xcconfig (gitignored)","artifact")
n_linux=p.box(620,600,460,220,"Linux laptop","node")
p.box(650,660,400,60,"Swift 6.3.2: swift test for YesChefCore","artifact")
p.box(650,740,400,60,"yeschef-demo: terminal backup demo","artifact")
n_gh=p.box(1160,440,380,150,"GitHub: spheritual/yeschef","node")
n_fig=p.box(1160,640,380,150,"Figma file (design source)","node")
p.edge(n_phone,n_google,"HTTPS 443, key in x-goog-api-key header")
p.edge(n_mac,n_phone,"build and install")
p.edge(n_mac,n_gh,"push and pull","dashed")
p.edge(n_linux,n_gh,"push and pull","dashed")
p.edge(n_linux,n_google,"live tests","dashed")
p.edge(n_fig,n_gh,"exports to design/","dashed")
pages.append(p)

#11 navigation map
p=Page("11 Navigation map",1500,860)
p.header("11. Navigation map","Every screen and how the cook reaches it. The app is one main screen; everything else opens on top of it as a sheet, except cook mode, which covers the full screen.")
main=p.box(560,330,260,110,"<b>Main screen</b><br>Basil in the top third, subtitle bar as the prompt box, recipes and output below","system")
burger=p.box(560,160,260,60,"<b>Burger menu</b> (top left)","box")
week=p.box(80,140,200,60,"This week (top bun)")
recipes=p.box(80,230,200,60,"Recipes (lettuce)")
shop=p.box(80,320,200,60,"Shopping list (tomato)")
house=p.box(80,410,200,60,"Household (cheese)")
imp=p.box(80,500,200,60,"Import a recipe (patty)")
sett=p.box(80,590,200,60,"Settings (bottom bun)")
chat=p.box(1000,180,220,70,"<b>Chat</b> (bubble, bottom right, or mic)")
learn=p.box(1000,330,220,70,"<b>Learning card</b> on the main screen")
recipe=p.box(560,560,260,70,"<b>Recipe</b> with steps and technique notes")
cookm=p.box(560,680,260,70,"<b>Cook mode</b> (full screen), timers")
rate=p.box(1000,680,220,70,"<b>Rating sheet</b>, 1 to 5 stars")
p.edge(main,burger,"tap the burger")
for d in (week,recipes,shop,house,imp,sett):
    p.edge(burger,d,"")
p.edge(main,chat,"tap the bubble")
p.edge(main,learn,"","line")
p.edge(week,recipe,"tap a dinner")
p.edge(recipes,recipe,"")
p.edge(imp,recipe,"photo read by Gemma")
p.edge(recipe,cookm,"Start cooking")
p.edge(cookm,rate,"Done")
pages.append(p)

#12 wireframes
p=Page("12 Wireframes",1700,980)
p.header("12. Low-fidelity wireframes","Layout only, in grey, before color. The numbered notes say what each block does. The Figma frames and design/screens show the finished look.")
def phone(page,x,title):
    page.box(x,130,260,560,title,"phone")
def wire(page,x,y,w,h,text,kind="wire"):
    return page.box(x,y,w,h,text,kind)
#main
phone(p,40,"Main screen")
wire(p,55,145,40,40,"menu","wirecircle")
wire(p,180,145,110,26,"streak, points")
wire(p,110,180,120,110,"1. Basil","wiredark")
wire(p,55,300,230,48,"2. subtitle bar = prompt box, mic")
wire(p,55,365,230,24,"Tonight")
wire(p,55,395,230,130,"3. recipe card: photo, title, time, Start cooking")
wire(p,55,535,230,24,"This week")
wire(p,55,565,70,50,"stat")
wire(p,135,565,70,50,"stat")
wire(p,215,565,70,50,"stat")
wire(p,235,626,44,44,"4. chat","wirecircle")
#burger open
phone(p,340,"Burger menu open")
for i,(name,kind) in enumerate([("top bun: This week","wiredark"),("lettuce: Recipes","wire"),("tomato: Shopping list","wiredark"),("cheese: Household","wire"),("patty: Import a recipe","wiredark"),("bottom bun: Settings","wire")]):
    wire(p,355,150+i*52,200,44,name,kind)
wire(p,355,470,230,200,"rest of the screen dimmed; tap outside to close")
#cook mode
phone(p,640,"Cook mode")
wire(p,655,150,230,26,"step 3 of 7, close")
wire(p,655,190,230,120,"5. the step in large text","wiredark")
wire(p,655,320,230,80,"6. why it matters (technique note)")
wire(p,655,410,230,60,"7. timer: start, pause, time left")
wire(p,655,480,230,48,"subtitle bar: ask Basil about this step")
wire(p,655,600,110,44,"Back")
wire(p,775,600,110,44,"Next or Done","wiredark")
#chat
phone(p,940,"Chat")
wire(p,955,150,230,40,"Basil, close")
wire(p,995,205,190,50,"Basil's message")
wire(p,955,265,190,40,"your message","wiredark")
wire(p,995,315,190,70,"Basil's answer")
wire(p,955,560,180,44,"8. type a question")
wire(p,1141,560,44,44,"mic","wirecircle")
#import
phone(p,1240,"Import a recipe")
wire(p,1255,150,230,40,"Import a recipe, close")
wire(p,1255,205,230,200,"9. photo picker, then the chosen photo","wiredark")
wire(p,1255,420,230,48,"Read it with Gemma")
wire(p,1255,480,230,120,"the recipe Basil read, ready to cook")
p.box(40,720,1620,220,"<b>Notes</b><br>1. Basil changes mood with what's happening (tab 8). 2. The subtitle bar shows his last line and takes typed questions. 3. The output area shows tonight's dinner, the week or the current recipe. 4. The chat bubble opens the full conversation. 5 to 7. Cook mode keeps one step on screen, with the reason behind it and its own timer. 8. Typed and spoken questions go to the same askChef call. 9. Photo import is the multimodal Gemma call, and the recipe it returns is checked for allergens before it's shown.","note")
pages.append(p)

#13 file structure
p=Page("13 File structure",1500,1060)
p.header("13. File structure","What each folder in the repo holds. gummi-main is another project's code that a teammate committed as reference; it isn't part of yeschef!.")
tree="""yeschef/
  README.md                  what it is, the model and its license, how to run
  LICENSE                    Apache 2.0
  CLAUDE.md                  working notes for the coding agents
  .mcp.json                  Figma's MCP server for the agents
  YesChef.xcodeproj/         the Xcode project
  Config/YesChef.xcconfig    build settings; includes Secrets.xcconfig (gitignored)
  YesChef/                   the iPhone app target
    YesChefApp.swift, ContentView.swift, AppModel.swift, AppSecrets.swift
    Main/                    MainScreen, BasilView, BurgerMenu, MenuPages
    Cook/                    CookModeView with timers and the rating sheet
    Chat/                    ChatView
    Import/                  ImportView for recipe photos
    Learning/                LearningCard
    Voice/                   BasilVoice, MicButton
    Theme/                   Theme colors and fonts
    Assets.xcassets/         Basil and the pan with steam
  YesChefCore/               Swift package, no UI, builds on Mac and Linux
    Sources/YesChefCore/Gemma/      GemmaClient, MealPlanner, Prompts, SampleData
    Sources/YesChefCore/Learning/   PreferenceModel, Recommender, HardRules, FeatureEncoder
    Tests/YesChefCoreTests/         offline tests and live Gemini tests
  YesChefDemo/               terminal demo, the backup for the stage
  design/                    Figma exports: screens, SVG assets, tokens, screen code
  docs/                      requirements, architecture, and this design set
    design/                  yeschef.drawio, the feature sheet, the generator
  .plans/                    coding checklist and the feedback learning spec
  .claude/skills/            interview, swiftui-pro, swiftui-expert-skill
  gummi-main/                another project, committed as character reference"""
p.box(40,120,1420,900,html.escape(tree).replace("\n","<br>").replace("  ","&nbsp;&nbsp;"),"mono")
pages.append(p)

def write_drawio(path):
    mxfile=ET.Element("mxfile",host="build_diagrams.py",type="device")
    for n,page in enumerate(pages,1):
        diagram=ET.SubElement(mxfile,"diagram",id=f"page{n}",name=page.name)
        model=ET.SubElement(diagram,"mxGraphModel",dx="1400",dy="900",grid="1",gridSize="10",guides="1",tooltips="1",connect="1",arrows="1",fold="1",page="1",pageScale="1",pageWidth=str(page.width),pageHeight=str(page.height),math="0",shadow="0",background=CREAM)
        root=ET.SubElement(model,"root")
        ET.SubElement(root,"mxCell",id="0")
        ET.SubElement(root,"mxCell",id="1",parent="0")
        for c in page.cells:
            if c.get("vertex"):
                cell=ET.SubElement(root,"mxCell",id=c["id"],value=c["text"],style=c["style"],vertex="1",parent=c["parent"])
                ET.SubElement(cell,"mxGeometry",x=str(c["x"]),y=str(c["y"]),width=str(c["w"]),height=str(c["h"]),**{"as":"geometry"})
            elif "points" in c:
                cell=ET.SubElement(root,"mxCell",id=c["id"],value=c["text"],style=c["style"],edge="1",parent="1")
                geo=ET.SubElement(cell,"mxGeometry",relative="1",**{"as":"geometry"})
                x1,y,x2,_=c["points"]
                ET.SubElement(geo,"mxPoint",x=str(x1),y=str(y),**{"as":"sourcePoint"})
                ET.SubElement(geo,"mxPoint",x=str(x2),y=str(y),**{"as":"targetPoint"})
            else:
                cell=ET.SubElement(root,"mxCell",id=c["id"],value=c["text"],style=c["style"],edge="1",parent="1",source=c["src"],target=c["dst"])
                ET.SubElement(cell,"mxGeometry",relative="1",**{"as":"geometry"})
    ET.indent(mxfile)
    path.write_text(ET.tostring(mxfile,encoding="unicode")+"\n",encoding="utf-8")

def check(pages):
    #every edge has to point at a cell on its own page, and ids can't repeat
    problems=[]
    for page in pages:
        ids=[c["id"] for c in page.cells]
        if len(ids)!=len(set(ids)):
            problems.append(f"{page.name}: repeated ids")
        known=set(ids)
        for c in page.cells:
            if c.get("edge") and "points" not in c and not {c["src"],c["dst"]}<=known:
                problems.append(f"{page.name}: edge {c['id']} points at a missing cell")
            if c.get("vertex") and (c["x"]+c["w"]>page.width or c["y"]+c["h"]>page.height):
                problems.append(f"{page.name}: {re.sub('<[^>]+>',' ',c['text'])[:40]!r} runs off the page")
    return problems

def preview(directory):
    #a rough svg per tab: boxes, ellipses, diamonds, straight lines and plain text
    directory.mkdir(parents=True,exist_ok=True)
    for n,page in enumerate(pages,1):
        out=[f'<svg xmlns="http://www.w3.org/2000/svg" width="{page.width}" height="{page.height}" font-family="Helvetica" font-size="12">',f'<rect width="100%" height="100%" fill="{CREAM}"/>']
        centers={}
        for c in page.cells:
            if not c.get("vertex"):
                continue
            x,y,w,h=c["x"],c["y"],c["w"],c["h"]
            centers[c["id"]]=(x+w/2,y+h/2)
            fill=re.search(r"fillColor=([^;]+)",c["style"])
            fill=fill.group(1) if fill and fill.group(1)!="none" else "none"
            if c["kind"] in ("title","caption"):
                fill="none"
            if "ellipse" in c["style"] or c["kind"]=="actor":
                out.append(f'<ellipse cx="{x+w/2}" cy="{y+h/2}" rx="{w/2}" ry="{h/2}" fill="{fill}" stroke="#555"/>')
            elif "rhombus" in c["style"]:
                out.append(f'<polygon points="{x+w/2},{y} {x+w},{y+h/2} {x+w/2},{y+h} {x},{y+h/2}" fill="{fill}" stroke="#555"/>')
            elif c["kind"] not in ("title","caption"):
                out.append(f'<rect x="{x}" y="{y}" width="{w}" height="{h}" rx="6" fill="{fill}" stroke="#555"/>')
            plain=re.sub(r"<hr[^>]*>","\n",re.sub(r"<br>","\n",c["text"]))
            plain=html.unescape(re.sub(r"<[^>]+>","",plain))
            lines=[]
            per=max(int(w/7),8)
            for raw in plain.split("\n"):
                while len(raw)>per:
                    cut=raw.rfind(" ",0,per)
                    cut=cut if cut>0 else per
                    lines.append(raw[:cut]);raw=raw[cut:].lstrip()
                lines.append(raw)
            ty=y+(h+12 if c["kind"]=="actor" else 16)
            for line in lines[:40]:
                out.append(f'<text x="{x+6}" y="{ty}">{html.escape(line)}</text>')
                ty+=15
        for c in page.cells:
            if not c.get("edge"):
                continue
            if "points" in c:
                x1,y1,x2,_=c["points"];y2=y1
            else:
                (x1,y1),(x2,y2)=centers[c["src"]],centers[c["dst"]]
            dash=' stroke-dasharray="5,4"' if "dashed=1" in c["style"] else ""
            out.append(f'<line x1="{x1}" y1="{y1}" x2="{x2}" y2="{y2}" stroke="#333"{dash}/>')
            if c["text"]:
                out.append(f'<text x="{(x1+x2)/2}" y="{(y1+y2)/2-4}" fill="#B00">{html.escape(html.unescape(re.sub("<[^>]+>","",c["text"])))}</text>')
        out.append("</svg>")
        (directory/f"{n:02d}.svg").write_text("\n".join(out),encoding="utf-8")

def export(directory):
    #draw.io's own renderer, from the Flathub app (flatpak install flathub com.jgraph.drawio.desktop)
    # -e embeds the diagram, which keeps the PNGs and SVGs editable in draw.io
    import subprocess
    directory.mkdir(parents=True,exist_ok=True)
    drawio=["flatpak","run","com.jgraph.drawio.desktop"]
    jobs=[]
    for n,page in enumerate(pages,1):
        slug=re.sub(r"[^a-z0-9]+","-",page.name.lower()).strip("-")
        slug=re.sub(r"^\d+-","",slug)
        for fmt,extra in (("png",["-s","2"]),("svg",[])):
            jobs.append(["-x","-f",fmt,"-p",str(n),"-b","20","-e",*extra,"-o",str(directory/f"{n:02d}-{slug}.{fmt}"),str(OUT)])
    jobs.append(["-x","-f","pdf","-a","--crop","-o",str(directory/"yeschef-design.pdf"),str(OUT)])
    failed=0
    for job in jobs:
        result=subprocess.run(drawio+job,capture_output=True,text=True,timeout=180)
        target=Path(job[job.index("-o")+1])
        if result.returncode!=0 or not target.exists() or target.stat().st_size==0:
            failed+=1
            print(f"export failed: {target.name} (exit {result.returncode})")
    print(f"exported {len(jobs)-failed} of {len(jobs)} files to {directory}")
    return failed

if __name__=="__main__":
    problems=check(pages)
    for problem in problems:
        print(problem)
    write_drawio(OUT)
    print(f"wrote {OUT} with {len(pages)} tabs")
    if len(sys.argv)==3 and sys.argv[1]=="--preview":
        preview(Path(sys.argv[2]))
        print(f"wrote previews to {sys.argv[2]}")
    if len(sys.argv)==2 and sys.argv[1]=="--export":
        problems+=["export"]*export(OUT.parent/"export")
    sys.exit(1 if problems else 0)
