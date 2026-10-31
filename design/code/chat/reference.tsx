const assetPathPrefix = "assets";
const imgRecipePhotography = `${assetPathPrefix}/recipe-photography.png`;
const imgIosSignal = `${assetPathPrefix}/ios-signal.svg`;
const imgIosWifiSignal = `${assetPathPrefix}/ios-wifi-signal.svg`;
const imgIosBatteryFull = `${assetPathPrefix}/ios-battery-full.svg`;
const imgBasilTheChef = `${assetPathPrefix}/basil-the-chef.svg`;
const imgArrowLeft = `${assetPathPrefix}/arrow-left.svg`;
const imgBasilTheChef1 = `${assetPathPrefix}/basil-the-chef1.svg`;
const imgEllipsis = `${assetPathPrefix}/ellipsis.svg`;
const imgUsersRound = `${assetPathPrefix}/users-round.svg`;
const imgCircleCheck = `${assetPathPrefix}/circle-check.svg`;
const imgArrowUp = `${assetPathPrefix}/arrow-up.svg`;
const imgHouse = `${assetPathPrefix}/house.svg`;
const imgCalendarDays = `${assetPathPrefix}/calendar-days.svg`;
const imgShoppingBasket = `${assetPathPrefix}/shopping-basket.svg`;
const imgBookOpen = `${assetPathPrefix}/book-open.svg`;
const imgUsersRound1 = `${assetPathPrefix}/users-round1.svg`;

export default function ChatWithBasil() {
  return (
    <div className="bg-[#f8f5ec] content-stretch flex flex-col items-start overflow-clip relative rounded-[32px] size-full" data-node-id="4:244" data-name="Chat with Basil">
      <div className="content-stretch flex h-[50px] items-center justify-between overflow-clip px-[28px] relative shrink-0 w-full" data-node-id="4:245" data-name="Status bar">
        <p className="[word-break:break-word] font-['Inter:Semi_Bold'] font-semibold leading-[normal] not-italic relative shrink-0 text-[#263b2e] text-[14px] whitespace-nowrap" data-node-id="4:246">
          9:41
        </p>
        <div className="content-stretch flex gap-[5px] items-center overflow-clip relative shrink-0" data-node-id="4:247" data-name="Device status">
          <div className="relative shrink-0 size-[17px]" data-node-id="4:248" data-name="ios-signal">
            <img alt="" className="absolute block inset-0 max-w-none size-full" src={imgIosSignal} />
          </div>
          <div className="relative shrink-0 size-[17px]" data-node-id="4:250" data-name="ios-wifi-signal">
            <img alt="" className="absolute block inset-0 max-w-none size-full" src={imgIosWifiSignal} />
          </div>
          <div className="h-[17px] relative shrink-0 w-[24px]" data-node-id="4:252" data-name="ios-battery-full">
            <img alt="" className="absolute block inset-0 max-w-none size-full" src={imgIosBatteryFull} />
          </div>
        </div>
      </div>
      <div className="bg-[#e7eccd] h-[173px] overflow-clip relative shrink-0 w-full" data-node-id="6:274" data-name="Chef header">
        <div className="absolute content-stretch flex flex-col h-[153px] items-center left-[135px] top-[10px] w-[132px]" data-node-id="6:32" data-name="Basil top hero">
          <div className="h-[153px] relative shrink-0 w-[132px]" data-node-id="6:33" data-name="Basil the chef">
            <img alt="" className="absolute block inset-0 max-w-none size-full" src={imgBasilTheChef} />
          </div>
        </div>
      </div>
      <div className="content-stretch flex flex-col gap-[24px] items-start min-h-[846px] overflow-clip pb-[24px] pt-[14px] px-[24px] relative shrink-0 w-full" data-node-id="4:254" data-name="Page content">
        <div className="content-stretch flex gap-[10px] items-center overflow-clip relative shrink-0 w-full" data-node-id="4:255" data-name="Chat header">
          <div className="relative shrink-0 size-[21px]" data-node-id="4:256" data-name="arrow-left">
            <img alt="" className="absolute block inset-0 max-w-none size-full" src={imgArrowLeft} />
          </div>
          <div className="bg-[#e7eccd] content-stretch flex items-center justify-center overflow-clip relative rounded-[100px] shrink-0 size-[51px]" data-node-id="4:258" data-name="Companion avatar">
            <div className="h-[47.25px] relative shrink-0 w-[42px]" data-node-id="4:259" data-name="Basil the chef">
              <img alt="" className="absolute block inset-0 max-w-none size-full" src={imgBasilTheChef1} />
            </div>
          </div>
          <div className="[word-break:break-word] content-stretch flex flex-[1_0_0] flex-col gap-[4px] items-start leading-[normal] min-w-px overflow-clip relative whitespace-nowrap" data-node-id="4:285" data-name="Companion identity">
            <p className="font-['Fraunces:SemiBold'] font-semibold relative shrink-0 text-[#263b2e] text-[26px]" data-node-id="4:286" style={{ fontVariationSettings: '"SOFT" 0, "WONK" 1' }}>
              Basil
            </p>
            <p className="font-['Inter:Regular'] font-normal not-italic relative shrink-0 text-[#386347] text-[10px]" data-node-id="4:287">
              Your chef, always in your corner
            </p>
          </div>
          <div className="relative shrink-0 size-[22px]" data-node-id="4:288" data-name="ellipsis">
            <img alt="" className="absolute block inset-0 max-w-none size-full" src={imgEllipsis} />
          </div>
        </div>
        <div className="bg-[#e7eccd] content-stretch flex gap-[8px] items-center overflow-clip px-[12px] py-[10px] relative rounded-[10px] shrink-0 w-full" data-node-id="4:290" data-name="Household context">
          <div className="relative shrink-0 size-[16px]" data-node-id="4:291" data-name="users-round">
            <img alt="" className="absolute block inset-0 max-w-none size-full" src={imgUsersRound} />
          </div>
          <p className="[word-break:break-word] flex-[1_0_0] font-['Inter:Regular'] font-normal leading-[1.45] min-w-px not-italic relative text-[#386347] text-[10px]" data-node-id="4:293">
            Morgan kitchen · 4 people · Nut-free · £75/week
          </p>
        </div>
        <div className="content-stretch flex flex-col gap-[14px] items-start overflow-clip relative shrink-0 w-full" data-node-id="4:294" data-name="Meal planning conversation">
          <p className="[word-break:break-word] font-['Inter:Regular'] font-normal leading-[normal] min-w-full not-italic relative shrink-0 text-[#73796b] text-[10px] text-center w-[min-content]" data-node-id="4:295">
            TODAY · 9:38 AM
          </p>
          <div className="content-stretch flex items-start justify-end overflow-clip relative shrink-0 w-full" data-node-id="4:296" data-name="Message row">
            <div className="bg-[#386347] border border-[#386347] border-solid content-stretch flex flex-col items-start overflow-clip p-[15px] relative rounded-bl-[18px] rounded-br-[4px] rounded-tl-[18px] rounded-tr-[18px] shrink-0 w-[277px]" data-node-id="4:297" data-name="Your message">
              <p className="[word-break:break-word] font-['Inter:Regular'] font-normal leading-[1.45] not-italic relative shrink-0 text-[13px] text-white w-full" data-node-id="4:298">
                Wednesday is going to be busy. Can we do something veggie in 25 minutes?
              </p>
            </div>
          </div>
          <div className="content-stretch flex items-start overflow-clip relative shrink-0 w-full" data-node-id="4:299" data-name="Message row">
            <div className="bg-[#fffef8] border border-[#dfe2d3] border-solid content-stretch flex flex-col items-start overflow-clip p-[15px] relative rounded-bl-[4px] rounded-br-[18px] rounded-tl-[18px] rounded-tr-[18px] shrink-0 w-[318px]" data-node-id="4:300" data-name="Basil’s message">
              <p className="[word-break:break-word] font-['Inter:Regular'] font-normal leading-[1.45] not-italic relative shrink-0 text-[#263b2e] text-[13px] w-full" data-node-id="4:301">
                Absolutely. How about sweet potato tacos? Mild for Leo, nut-free for Mia, and lots of lovely veg for Sam. About £1.80 a portion.
              </p>
            </div>
          </div>
          <div className="bg-[#fffef8] border border-[#dfe2d3] border-solid content-stretch flex gap-[11px] items-center overflow-clip p-[12px] relative rounded-[16px] shrink-0 w-[318px]" data-node-id="4:302" data-name="Suggested recipe">
            <div className="h-[76px] relative rounded-[10px] shrink-0 w-[75px]" data-node-id="4:303" data-name="Recipe photography">
              <img alt="" className="absolute inset-0 max-w-none object-cover pointer-events-none rounded-[10px] size-full" src={imgRecipePhotography} />
            </div>
            <div className="[word-break:break-word] content-stretch flex flex-[1_0_0] flex-col gap-[6px] items-start min-w-px overflow-clip relative" data-node-id="4:304" data-name="Recipe suggestion">
              <p className="font-['Fraunces:SemiBold'] font-semibold leading-[1.14] min-w-full relative shrink-0 text-[#263b2e] text-[19px] w-[min-content]" data-node-id="4:305" style={{ fontVariationSettings: '"SOFT" 0, "WONK" 1' }}>
                Sweet potato tacos
              </p>
              <p className="font-['Inter:Regular'] font-normal leading-[1.45] min-w-full not-italic relative shrink-0 text-[#73796b] text-[10px] w-[min-content]" data-node-id="4:306">
                25 min · Serves 4 · ★ 4.9
              </p>
              <p className="font-['Inter:Semi_Bold'] font-semibold leading-[normal] not-italic relative shrink-0 text-[#386347] text-[11px] whitespace-nowrap" data-node-id="4:307">
                Have a peek →
              </p>
            </div>
          </div>
          <div className="content-stretch flex items-start justify-end overflow-clip relative shrink-0 w-full" data-node-id="4:308" data-name="Message row">
            <div className="bg-[#386347] border border-[#386347] border-solid content-stretch flex flex-col items-start overflow-clip p-[15px] relative rounded-bl-[18px] rounded-br-[4px] rounded-tl-[18px] rounded-tr-[18px] shrink-0 w-[277px]" data-node-id="4:309" data-name="Your message">
              <p className="[word-break:break-word] font-['Inter:Regular'] font-normal leading-[1.45] not-italic relative shrink-0 text-[13px] text-white w-full" data-node-id="4:310">
                Perfect, swap it in. Can we stay under our weekly budget?
              </p>
            </div>
          </div>
          <div className="bg-[#e7eccd] content-stretch flex flex-col gap-[12px] items-start overflow-clip p-[15px] relative rounded-bl-[4px] rounded-br-[18px] rounded-tl-[18px] rounded-tr-[18px] shrink-0 w-[318px]" data-node-id="4:311" data-name="Plan update">
            <div className="content-stretch flex gap-[6px] items-center overflow-clip relative shrink-0" data-node-id="4:312" data-name="Update status">
              <div className="relative shrink-0 size-[17px]" data-node-id="4:313" data-name="circle-check">
                <img alt="" className="absolute block inset-0 max-w-none size-full" src={imgCircleCheck} />
              </div>
              <p className="[word-break:break-word] font-['Inter:Bold'] font-bold leading-[normal] not-italic relative shrink-0 text-[#386347] text-[12px] whitespace-nowrap" data-node-id="4:315">
                Wednesday, sorted.
              </p>
            </div>
            <p className="[word-break:break-word] font-['Inter:Regular'] font-normal leading-[1.45] min-w-full not-italic relative shrink-0 text-[#263b2e] text-[13px] w-[min-content]" data-node-id="4:316">
              Tacos are on the plan, and I’ve updated your shopping list. The week comes to about £68 — £7 under budget. More room for a little treat!
            </p>
            <p className="[word-break:break-word] font-['Inter:Semi_Bold'] font-semibold leading-[normal] not-italic relative shrink-0 text-[#386347] text-[12px] whitespace-nowrap" data-node-id="4:317">
              View your updated plan →
            </p>
          </div>
        </div>
        <div className="content-stretch flex flex-col gap-[12px] items-start overflow-clip relative shrink-0 w-full" data-node-id="4:318" data-name="Conversation controls">
          <div className="content-stretch flex gap-[7px] items-start overflow-clip relative shrink-0 w-full" data-node-id="4:319" data-name="Suggested prompts">
            <div className="bg-[#f0f1e7] content-stretch flex items-center overflow-clip px-[12px] py-[8px] relative rounded-[100px] shrink-0" data-node-id="4:320" data-name="Chip">
              <p className="[word-break:break-word] font-['Inter:Semi_Bold'] font-semibold leading-[normal] not-italic relative shrink-0 text-[#386347] text-[11px] whitespace-nowrap" data-node-id="4:321">
                Prep ahead tips?
              </p>
            </div>
            <div className="bg-[#f0f1e7] content-stretch flex items-center overflow-clip px-[12px] py-[8px] relative rounded-[100px] shrink-0" data-node-id="4:322" data-name="Chip">
              <p className="[word-break:break-word] font-['Inter:Semi_Bold'] font-semibold leading-[normal] not-italic relative shrink-0 text-[#386347] text-[11px] whitespace-nowrap" data-node-id="4:323">
                Use up my spinach
              </p>
            </div>
          </div>
          <div className="bg-[#fffef8] border border-[#dfe2d3] border-solid content-stretch flex gap-[8px] h-[52px] items-center overflow-clip pl-[15px] pr-[7px] relative rounded-[100px] shrink-0 w-full" data-node-id="4:324" data-name="Message composer">
            <p className="[word-break:break-word] flex-[1_0_0] font-['Inter:Regular'] font-normal leading-[1.45] min-w-px not-italic relative text-[#73796b] text-[13px]" data-node-id="4:325">
              Ask Basil anything…
            </p>
            <div className="bg-[#386347] content-stretch flex items-center justify-center overflow-clip relative rounded-[100px] shrink-0 size-[38px]" data-node-id="4:326" data-name="Send message">
              <div className="relative shrink-0 size-[19px]" data-node-id="4:327" data-name="arrow-up">
                <img alt="" className="absolute block inset-0 max-w-none size-full" src={imgArrowUp} />
              </div>
            </div>
          </div>
          <p className="[word-break:break-word] font-['Inter:Regular'] font-normal leading-[1.45] not-italic relative shrink-0 text-[#73796b] text-[9px] text-center w-full" data-node-id="4:329">
            A little help from AI. Always double-check allergens.
          </p>
        </div>
      </div>
      <div className="bg-[#fffef8] border-[#dfe2d3] border-solid border-t content-stretch flex flex-col gap-[12px] items-center overflow-clip pb-[8px] pt-[10px] px-[15px] relative shrink-0 w-full" data-node-id="4:330" data-name="Bottom navigation">
        <div className="content-stretch flex items-start justify-between overflow-clip relative shrink-0 w-full" data-node-id="4:331" data-name="Destinations">
          <div className="content-stretch flex flex-col gap-[4px] items-center overflow-clip relative shrink-0 w-[60px]" data-node-id="4:332" data-name="Navigation item">
            <div className="bg-[#e7eccd] content-stretch flex h-[29px] items-center justify-center overflow-clip relative rounded-[100px] shrink-0 w-[48px]" data-node-id="4:333" data-name="Active indicator">
              <div className="relative shrink-0 size-[21px]" data-node-id="4:334" data-name="house">
                <img alt="" className="absolute block inset-0 max-w-none size-full" src={imgHouse} />
              </div>
            </div>
            <p className="[word-break:break-word] font-['Inter:Bold'] font-bold leading-[normal] not-italic relative shrink-0 text-[#386347] text-[10px] whitespace-nowrap" data-node-id="4:336">
              Home
            </p>
          </div>
          <div className="content-stretch flex flex-col gap-[4px] items-center overflow-clip relative shrink-0 w-[60px]" data-node-id="4:337" data-name="Navigation item">
            <div className="bg-[#fffef8] content-stretch flex h-[29px] items-center justify-center overflow-clip relative rounded-[100px] shrink-0 w-[48px]" data-node-id="4:338" data-name="Active indicator">
              <div className="relative shrink-0 size-[21px]" data-node-id="4:339" data-name="calendar-days">
                <img alt="" className="absolute block inset-0 max-w-none size-full" src={imgCalendarDays} />
              </div>
            </div>
            <p className="[word-break:break-word] font-['Inter:Regular'] font-normal leading-[normal] not-italic relative shrink-0 text-[#73796b] text-[10px] whitespace-nowrap" data-node-id="4:341">
              Plan
            </p>
          </div>
          <div className="content-stretch flex flex-col gap-[4px] items-center overflow-clip relative shrink-0 w-[60px]" data-node-id="4:342" data-name="Navigation item">
            <div className="bg-[#fffef8] content-stretch flex h-[29px] items-center justify-center overflow-clip relative rounded-[100px] shrink-0 w-[48px]" data-node-id="4:343" data-name="Active indicator">
              <div className="relative shrink-0 size-[21px]" data-node-id="4:344" data-name="shopping-basket">
                <img alt="" className="absolute block inset-0 max-w-none size-full" src={imgShoppingBasket} />
              </div>
            </div>
            <p className="[word-break:break-word] font-['Inter:Regular'] font-normal leading-[normal] not-italic relative shrink-0 text-[#73796b] text-[10px] whitespace-nowrap" data-node-id="4:346">
              Shop
            </p>
          </div>
          <div className="content-stretch flex flex-col gap-[4px] items-center overflow-clip relative shrink-0 w-[60px]" data-node-id="4:347" data-name="Navigation item">
            <div className="bg-[#fffef8] content-stretch flex h-[29px] items-center justify-center overflow-clip relative rounded-[100px] shrink-0 w-[48px]" data-node-id="4:348" data-name="Active indicator">
              <div className="relative shrink-0 size-[21px]" data-node-id="4:349" data-name="book-open">
                <img alt="" className="absolute block inset-0 max-w-none size-full" src={imgBookOpen} />
              </div>
            </div>
            <p className="[word-break:break-word] font-['Inter:Regular'] font-normal leading-[normal] not-italic relative shrink-0 text-[#73796b] text-[10px] whitespace-nowrap" data-node-id="4:351">
              Recipes
            </p>
          </div>
          <div className="content-stretch flex flex-col gap-[4px] items-center overflow-clip relative shrink-0 w-[60px]" data-node-id="4:352" data-name="Navigation item">
            <div className="bg-[#fffef8] content-stretch flex h-[29px] items-center justify-center overflow-clip relative rounded-[100px] shrink-0 w-[48px]" data-node-id="4:353" data-name="Active indicator">
              <div className="relative shrink-0 size-[21px]" data-node-id="4:354" data-name="users-round">
                <img alt="" className="absolute block inset-0 max-w-none size-full" src={imgUsersRound1} />
              </div>
            </div>
            <p className="[word-break:break-word] font-['Inter:Regular'] font-normal leading-[normal] not-italic relative shrink-0 text-[#73796b] text-[10px] whitespace-nowrap" data-node-id="4:356">
              You
            </p>
          </div>
        </div>
        <div className="bg-[#263b2e] h-[4px] relative rounded-[100px] shrink-0 w-[122px]" data-node-id="4:357" data-name="Home indicator" />
      </div>
    </div>
  );
}