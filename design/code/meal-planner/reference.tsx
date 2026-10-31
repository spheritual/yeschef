const assetPathPrefix = "assets";
const imgRecipePhotography = `${assetPathPrefix}/recipe-photography.png`;
const imgRecipePhotography1 = `${assetPathPrefix}/recipe-photography1.png`;
const imgRecipePhotography2 = `${assetPathPrefix}/recipe-photography2.png`;
const imgRecipePhotography3 = `${assetPathPrefix}/recipe-photography3.png`;
const imgRecipePhotography4 = `${assetPathPrefix}/recipe-photography4.png`;
const imgRecipePhotography5 = `${assetPathPrefix}/recipe-photography5.png`;
const imgRecipePhotography6 = `${assetPathPrefix}/recipe-photography6.png`;
const imgIosSignal = `${assetPathPrefix}/ios-signal.svg`;
const imgIosWifiSignal = `${assetPathPrefix}/ios-wifi-signal.svg`;
const imgIosBatteryFull = `${assetPathPrefix}/ios-battery-full.svg`;
const imgBasilTheChefHeader = `${assetPathPrefix}/basil-the-chef-header.svg`;
const imgCalendarDays = `${assetPathPrefix}/calendar-days.svg`;
const imgChevronLeft = `${assetPathPrefix}/chevron-left.svg`;
const imgChevronRight = `${assetPathPrefix}/chevron-right.svg`;
const imgSlidersHorizontal = `${assetPathPrefix}/sliders-horizontal.svg`;
const imgShieldCheck = `${assetPathPrefix}/shield-check.svg`;
const imgLeaf = `${assetPathPrefix}/leaf.svg`;
const imgArrowLeftRight = `${assetPathPrefix}/arrow-left-right.svg`;
const imgSun = `${assetPathPrefix}/sun.svg`;
const imgShoppingBasket = `${assetPathPrefix}/shopping-basket.svg`;
const imgRefreshCw = `${assetPathPrefix}/refresh-cw.svg`;
const imgHouse = `${assetPathPrefix}/house.svg`;
const imgCalendarDays1 = `${assetPathPrefix}/calendar-days1.svg`;
const imgShoppingBasket1 = `${assetPathPrefix}/shopping-basket1.svg`;
const imgBookOpen = `${assetPathPrefix}/book-open.svg`;
const imgUsersRound = `${assetPathPrefix}/users-round.svg`;

export default function WeeklyMealPlanner() {
  return (
    <div className="bg-[#f8f5ec] content-stretch flex flex-col items-start overflow-clip relative rounded-[32px] size-full" data-node-id="4:943" data-name="Weekly meal planner">
      <div className="grid-cols-[max-content] grid-rows-[max-content] inline-grid leading-[0] place-items-start relative shrink-0" data-node-id="4:1315">
        <div className="col-1 content-stretch flex h-[50px] items-center justify-between ml-0 mt-0 overflow-clip px-[28px] relative row-1 w-[402px]" data-node-id="4:944" data-name="Status bar">
          <p className="[word-break:break-word] font-['Inter:Semi_Bold'] font-semibold leading-[normal] not-italic relative shrink-0 text-[#263b2e] text-[14px] whitespace-nowrap" data-node-id="4:945">
            9:41
          </p>
          <div className="content-stretch flex gap-[5px] items-center overflow-clip relative shrink-0" data-node-id="4:946" data-name="Device status">
            <div className="relative shrink-0 size-[17px]" data-node-id="4:947" data-name="ios-signal">
              <img alt="" className="absolute block inset-0 max-w-none size-full" src={imgIosSignal} />
            </div>
            <div className="relative shrink-0 size-[17px]" data-node-id="4:949" data-name="ios-wifi-signal">
              <img alt="" className="absolute block inset-0 max-w-none size-full" src={imgIosWifiSignal} />
            </div>
            <div className="h-[17px] relative shrink-0 w-[24px]" data-node-id="4:951" data-name="ios-battery-full">
              <img alt="" className="absolute block inset-0 max-w-none size-full" src={imgIosBatteryFull} />
            </div>
          </div>
        </div>
        <div className="bg-[#e7eccd] col-1 h-[173px] ml-0 mt-[50px] overflow-clip relative row-1 w-[402px]" data-node-id="6:277" data-name="Chef header">
          <div className="absolute h-[153px] left-[133px] top-[10px] w-[136px]" data-node-id="6:179" data-name="Basil the chef header">
            <img alt="" className="absolute block inset-0 max-w-none size-full" src={imgBasilTheChefHeader} />
          </div>
        </div>
        <div className="col-1 content-stretch flex flex-col gap-[24px] items-start min-h-[1006px] ml-0 mt-[223px] overflow-clip pb-[24px] pt-[14px] px-[24px] relative row-1 w-[402px]" data-node-id="4:953" data-name="Page content">
          <div className="content-stretch flex flex-col items-start overflow-clip relative shrink-0 w-full" data-node-id="4:954" data-name="Page heading">
            <div className="content-stretch flex gap-[12px] items-center overflow-clip relative shrink-0 w-full" data-node-id="4:955" data-name="Heading row">
              <div className="[word-break:break-word] content-stretch flex flex-[1_0_0] flex-col gap-[5px] items-start min-w-px overflow-clip relative" data-node-id="4:956" data-name="Heading copy">
                <p className="font-['Fraunces:SemiBold'] font-semibold leading-[1.15] relative shrink-0 text-[#263b2e] text-[29px] tracking-[-0.7px] w-full" data-node-id="4:957" style={{ fontVariationSettings: '"SOFT" 0, "WONK" 1' }}>
                  A week, well fed.
                </p>
                <p className="font-['Inter:Regular'] font-normal leading-[1.45] not-italic relative shrink-0 text-[#73796b] text-[12px] w-full" data-node-id="4:958">
                  The Morgan kitchen · 4 people
                </p>
              </div>
              <div className="bg-[#fffef8] border border-[#dfe2d3] border-solid content-stretch flex items-center justify-center overflow-clip relative rounded-[100px] shrink-0 size-[38px]" data-node-id="4:959" data-name="Header action">
                <div className="relative shrink-0 size-[18px]" data-node-id="4:960" data-name="calendar-days">
                  <img alt="" className="absolute block inset-0 max-w-none size-full" src={imgCalendarDays} />
                </div>
              </div>
            </div>
          </div>
          <div className="bg-[#fffef8] border border-[#dfe2d3] border-solid content-stretch flex items-center justify-between overflow-clip p-[12px] relative rounded-[10px] shrink-0 w-full" data-node-id="4:962" data-name="Week selector">
            <div className="relative shrink-0 size-[18px]" data-node-id="4:963" data-name="chevron-left">
              <img alt="" className="absolute block inset-0 max-w-none size-full" src={imgChevronLeft} />
            </div>
            <p className="[word-break:break-word] font-['Inter:Semi_Bold'] font-semibold leading-[normal] not-italic relative shrink-0 text-[#263b2e] text-[14px] whitespace-nowrap" data-node-id="4:965">
              19 – 25 October
            </p>
            <div className="relative shrink-0 size-[18px]" data-node-id="4:966" data-name="chevron-right">
              <img alt="" className="absolute block inset-0 max-w-none size-full" src={imgChevronRight} />
            </div>
          </div>
          <div className="bg-[#e7eccd] content-stretch flex flex-col gap-[12px] items-start overflow-clip p-[15px] relative rounded-[20px] shrink-0 w-full" data-node-id="4:968" data-name="Planning criteria">
            <div className="content-stretch flex items-start justify-between overflow-clip relative shrink-0 w-full" data-node-id="4:969" data-name="Criteria heading">
              <p className="[word-break:break-word] font-['Inter:Bold'] font-bold leading-[normal] not-italic relative shrink-0 text-[#386347] text-[12px] whitespace-nowrap" data-node-id="4:970">
                Made for your household
              </p>
              <div className="relative shrink-0 size-[17px]" data-node-id="4:971" data-name="sliders-horizontal">
                <img alt="" className="absolute block inset-0 max-w-none size-full" src={imgSlidersHorizontal} />
              </div>
            </div>
            <div className="content-start flex flex-wrap gap-[6px] items-start overflow-clip relative shrink-0 w-full" data-node-id="4:973" data-name="Criteria controls">
              <div className="bg-[#f0f1e7] content-stretch flex gap-[5px] items-center overflow-clip px-[12px] py-[8px] relative rounded-[100px] shrink-0" data-node-id="4:974" data-name="Chip">
                <div className="relative shrink-0 size-[13px]" data-node-id="4:975" data-name="shield-check">
                  <img alt="" className="absolute block inset-0 max-w-none size-full" src={imgShieldCheck} />
                </div>
                <p className="[word-break:break-word] font-['Inter:Semi_Bold'] font-semibold leading-[normal] not-italic relative shrink-0 text-[#386347] text-[11px] whitespace-nowrap" data-node-id="4:977">
                  Nut-free
                </p>
              </div>
              <div className="bg-[#f0f1e7] content-stretch flex items-center overflow-clip px-[12px] py-[8px] relative rounded-[100px] shrink-0" data-node-id="4:978" data-name="Chip">
                <p className="[word-break:break-word] font-['Inter:Semi_Bold'] font-semibold leading-[normal] not-italic relative shrink-0 text-[#386347] text-[11px] whitespace-nowrap" data-node-id="4:979">
                  £75 / week
                </p>
              </div>
              <div className="bg-[#f0f1e7] content-stretch flex items-center overflow-clip px-[12px] py-[8px] relative rounded-[100px] shrink-0" data-node-id="4:980" data-name="Chip">
                <p className="[word-break:break-word] font-['Inter:Semi_Bold'] font-semibold leading-[normal] not-italic relative shrink-0 text-[#386347] text-[11px] whitespace-nowrap" data-node-id="4:981">
                  ≤ 35 min
                </p>
              </div>
              <div className="bg-[#f0f1e7] content-stretch flex gap-[5px] items-center overflow-clip px-[12px] py-[8px] relative rounded-[100px] shrink-0" data-node-id="4:982" data-name="Chip">
                <div className="relative shrink-0 size-[13px]" data-node-id="4:983" data-name="leaf">
                  <img alt="" className="absolute block inset-0 max-w-none size-full" src={imgLeaf} />
                </div>
                <p className="[word-break:break-word] font-['Inter:Semi_Bold'] font-semibold leading-[normal] not-italic relative shrink-0 text-[#386347] text-[11px] whitespace-nowrap" data-node-id="4:985">
                  3 veggie nights
                </p>
              </div>
              <div className="bg-[#f0f1e7] content-stretch flex items-center overflow-clip px-[12px] py-[8px] relative rounded-[100px] shrink-0" data-node-id="4:986" data-name="Chip">
                <p className="[word-break:break-word] font-['Inter:Semi_Bold'] font-semibold leading-[normal] not-italic relative shrink-0 text-[#386347] text-[11px] whitespace-nowrap" data-node-id="4:987">
                  Edit criteria
                </p>
              </div>
            </div>
          </div>
          <div className="content-stretch flex flex-col gap-[12px] items-start overflow-clip relative shrink-0 w-full" data-node-id="4:988" data-name="Meal schedule">
            <div className="content-stretch flex gap-[8px] items-start overflow-clip relative shrink-0 w-full" data-node-id="4:989" data-name="Meal type tabs">
              <div className="bg-[#386347] content-stretch flex items-center overflow-clip px-[12px] py-[8px] relative rounded-[100px] shrink-0" data-node-id="4:990" data-name="Chip">
                <p className="[word-break:break-word] font-['Inter:Semi_Bold'] font-semibold leading-[normal] not-italic relative shrink-0 text-[11px] text-white whitespace-nowrap" data-node-id="4:991">
                  Dinner
                </p>
              </div>
              <div className="bg-[#f0f1e7] content-stretch flex items-center overflow-clip px-[12px] py-[8px] relative rounded-[100px] shrink-0" data-node-id="4:992" data-name="Chip">
                <p className="[word-break:break-word] font-['Inter:Semi_Bold'] font-semibold leading-[normal] not-italic relative shrink-0 text-[#386347] text-[11px] whitespace-nowrap" data-node-id="4:993">
                  Breakfast
                </p>
              </div>
              <div className="bg-[#f0f1e7] content-stretch flex items-center overflow-clip px-[12px] py-[8px] relative rounded-[100px] shrink-0" data-node-id="4:994" data-name="Chip">
                <p className="[word-break:break-word] font-['Inter:Semi_Bold'] font-semibold leading-[normal] not-italic relative shrink-0 text-[#386347] text-[11px] whitespace-nowrap" data-node-id="4:995">
                  Lunch
                </p>
              </div>
            </div>
            <div className="bg-[#fffef8] border border-[#386347] border-solid content-stretch flex gap-[11px] items-center overflow-clip p-[10px] relative rounded-[14px] shrink-0 w-full" data-node-id="4:996" data-name="Day plan">
              <div className="[word-break:break-word] content-stretch flex flex-col gap-[3px] items-center leading-[normal] overflow-clip relative shrink-0 w-[32px] whitespace-nowrap" data-node-id="4:997" data-name="Day">
                <p className="font-['Inter:Bold'] font-bold not-italic relative shrink-0 text-[#386347] text-[9px]" data-node-id="4:998">
                  MON
                </p>
                <p className="font-['Fraunces:Regular'] font-normal relative shrink-0 text-[#263b2e] text-[23px]" data-node-id="4:999" style={{ fontVariationSettings: '"SOFT" 0, "WONK" 1' }}>
                  19
                </p>
              </div>
              <div className="h-[49px] relative rounded-[10px] shrink-0 w-[47px]" data-node-id="4:1000" data-name="Recipe photography">
                <img alt="" className="absolute inset-0 max-w-none object-cover pointer-events-none rounded-[10px] size-full" src={imgRecipePhotography} />
              </div>
              <div className="[word-break:break-word] content-stretch flex flex-[1_0_0] flex-col gap-[5px] items-start min-w-px not-italic overflow-clip relative" data-node-id="4:1001" data-name="Meal">
                <p className="font-['Inter:Semi_Bold'] font-semibold leading-[normal] relative shrink-0 text-[#263b2e] text-[12px] w-full" data-node-id="4:1002">{`Lemon & herb salmon`}</p>
                <p className="font-['Inter:Regular'] font-normal leading-[1.45] relative shrink-0 text-[#73796b] text-[10px] w-full" data-node-id="4:1003">
                  30 min · Serves 4
                </p>
              </div>
              <div className="relative shrink-0 size-[16px]" data-node-id="4:1004" data-name="arrow-left-right">
                <img alt="" className="absolute block inset-0 max-w-none size-full" src={imgArrowLeftRight} />
              </div>
            </div>
            <div className="bg-[#f8f5ec] border border-[#dfe2d3] border-solid content-stretch flex gap-[11px] items-center overflow-clip p-[10px] relative rounded-[14px] shrink-0 w-full" data-node-id="4:1006" data-name="Day plan">
              <div className="[word-break:break-word] content-stretch flex flex-col gap-[3px] items-center leading-[normal] overflow-clip relative shrink-0 w-[32px] whitespace-nowrap" data-node-id="4:1007" data-name="Day">
                <p className="font-['Inter:Bold'] font-bold not-italic relative shrink-0 text-[#73796b] text-[9px]" data-node-id="4:1008">
                  TUE
                </p>
                <p className="font-['Fraunces:Regular'] font-normal relative shrink-0 text-[#263b2e] text-[23px]" data-node-id="4:1009" style={{ fontVariationSettings: '"SOFT" 0, "WONK" 1' }}>
                  20
                </p>
              </div>
              <div className="h-[49px] relative rounded-[10px] shrink-0 w-[47px]" data-node-id="4:1010" data-name="Recipe photography">
                <img alt="" className="absolute inset-0 max-w-none object-cover pointer-events-none rounded-[10px] size-full" src={imgRecipePhotography1} />
              </div>
              <div className="[word-break:break-word] content-stretch flex flex-[1_0_0] flex-col gap-[5px] items-start min-w-px not-italic overflow-clip relative" data-node-id="4:1011" data-name="Meal">
                <p className="font-['Inter:Semi_Bold'] font-semibold leading-[normal] relative shrink-0 text-[#263b2e] text-[12px] w-full" data-node-id="4:1012">
                  Creamy spinach orzo
                </p>
                <p className="font-['Inter:Regular'] font-normal leading-[1.45] relative shrink-0 text-[#73796b] text-[10px] w-full" data-node-id="4:1013">
                  25 min · Vegetarian
                </p>
              </div>
              <div className="relative shrink-0 size-[16px]" data-node-id="4:1014" data-name="arrow-left-right">
                <img alt="" className="absolute block inset-0 max-w-none size-full" src={imgArrowLeftRight} />
              </div>
            </div>
            <div className="bg-[#f8f5ec] border border-[#dfe2d3] border-solid content-stretch flex gap-[11px] items-center overflow-clip p-[10px] relative rounded-[14px] shrink-0 w-full" data-node-id="4:1016" data-name="Day plan">
              <div className="[word-break:break-word] content-stretch flex flex-col gap-[3px] items-center leading-[normal] overflow-clip relative shrink-0 w-[32px] whitespace-nowrap" data-node-id="4:1017" data-name="Day">
                <p className="font-['Inter:Bold'] font-bold not-italic relative shrink-0 text-[#73796b] text-[9px]" data-node-id="4:1018">
                  WED
                </p>
                <p className="font-['Fraunces:Regular'] font-normal relative shrink-0 text-[#263b2e] text-[23px]" data-node-id="4:1019" style={{ fontVariationSettings: '"SOFT" 0, "WONK" 1' }}>
                  21
                </p>
              </div>
              <div className="h-[49px] relative rounded-[10px] shrink-0 w-[47px]" data-node-id="4:1020" data-name="Recipe photography">
                <img alt="" className="absolute inset-0 max-w-none object-cover pointer-events-none rounded-[10px] size-full" src={imgRecipePhotography2} />
              </div>
              <div className="[word-break:break-word] content-stretch flex flex-[1_0_0] flex-col gap-[5px] items-start min-w-px not-italic overflow-clip relative" data-node-id="4:1021" data-name="Meal">
                <p className="font-['Inter:Semi_Bold'] font-semibold leading-[normal] relative shrink-0 text-[#263b2e] text-[12px] w-full" data-node-id="4:1022">
                  Sweet potato tacos
                </p>
                <p className="font-['Inter:Regular'] font-normal leading-[1.45] relative shrink-0 text-[#73796b] text-[10px] w-full" data-node-id="4:1023">
                  25 min · Vegetarian
                </p>
              </div>
              <div className="relative shrink-0 size-[16px]" data-node-id="4:1024" data-name="arrow-left-right">
                <img alt="" className="absolute block inset-0 max-w-none size-full" src={imgArrowLeftRight} />
              </div>
            </div>
            <div className="bg-[#f8f5ec] border border-[#dfe2d3] border-solid content-stretch flex gap-[11px] items-center overflow-clip p-[10px] relative rounded-[14px] shrink-0 w-full" data-node-id="4:1026" data-name="Day plan">
              <div className="[word-break:break-word] content-stretch flex flex-col gap-[3px] items-center leading-[normal] overflow-clip relative shrink-0 w-[32px] whitespace-nowrap" data-node-id="4:1027" data-name="Day">
                <p className="font-['Inter:Bold'] font-bold not-italic relative shrink-0 text-[#73796b] text-[9px]" data-node-id="4:1028">
                  THU
                </p>
                <p className="font-['Fraunces:Regular'] font-normal relative shrink-0 text-[#263b2e] text-[23px]" data-node-id="4:1029" style={{ fontVariationSettings: '"SOFT" 0, "WONK" 1' }}>
                  22
                </p>
              </div>
              <div className="h-[49px] relative rounded-[10px] shrink-0 w-[47px]" data-node-id="4:1030" data-name="Recipe photography">
                <img alt="" className="absolute inset-0 max-w-none object-cover pointer-events-none rounded-[10px] size-full" src={imgRecipePhotography3} />
              </div>
              <div className="[word-break:break-word] content-stretch flex flex-[1_0_0] flex-col gap-[5px] items-start min-w-px not-italic overflow-clip relative" data-node-id="4:1031" data-name="Meal">
                <p className="font-['Inter:Semi_Bold'] font-semibold leading-[normal] relative shrink-0 text-[#263b2e] text-[12px] w-full" data-node-id="4:1032">{`Ginger chicken & rice`}</p>
                <p className="font-['Inter:Regular'] font-normal leading-[1.45] relative shrink-0 text-[#73796b] text-[10px] w-full" data-node-id="4:1033">
                  30 min · Serves 4
                </p>
              </div>
              <div className="relative shrink-0 size-[16px]" data-node-id="4:1034" data-name="arrow-left-right">
                <img alt="" className="absolute block inset-0 max-w-none size-full" src={imgArrowLeftRight} />
              </div>
            </div>
            <div className="bg-[#f8f5ec] border border-[#dfe2d3] border-solid content-stretch flex gap-[11px] items-center overflow-clip p-[10px] relative rounded-[14px] shrink-0 w-full" data-node-id="4:1036" data-name="Day plan">
              <div className="[word-break:break-word] content-stretch flex flex-col gap-[3px] items-center leading-[normal] overflow-clip relative shrink-0 w-[32px] whitespace-nowrap" data-node-id="4:1037" data-name="Day">
                <p className="font-['Inter:Bold'] font-bold not-italic relative shrink-0 text-[#73796b] text-[9px]" data-node-id="4:1038">
                  FRI
                </p>
                <p className="font-['Fraunces:Regular'] font-normal relative shrink-0 text-[#263b2e] text-[23px]" data-node-id="4:1039" style={{ fontVariationSettings: '"SOFT" 0, "WONK" 1' }}>
                  23
                </p>
              </div>
              <div className="h-[49px] relative rounded-[10px] shrink-0 w-[47px]" data-node-id="4:1040" data-name="Recipe photography">
                <img alt="" className="absolute inset-0 max-w-none object-cover pointer-events-none rounded-[10px] size-full" src={imgRecipePhotography4} />
              </div>
              <div className="[word-break:break-word] content-stretch flex flex-[1_0_0] flex-col gap-[5px] items-start min-w-px not-italic overflow-clip relative" data-node-id="4:1041" data-name="Meal">
                <p className="font-['Inter:Semi_Bold'] font-semibold leading-[normal] relative shrink-0 text-[#263b2e] text-[12px] w-full" data-node-id="4:1042">
                  Coconut chickpea curry
                </p>
                <p className="font-['Inter:Regular'] font-normal leading-[1.45] relative shrink-0 text-[#73796b] text-[10px] w-full" data-node-id="4:1043">
                  30 min · Vegetarian
                </p>
              </div>
              <div className="relative shrink-0 size-[16px]" data-node-id="4:1044" data-name="arrow-left-right">
                <img alt="" className="absolute block inset-0 max-w-none size-full" src={imgArrowLeftRight} />
              </div>
            </div>
            <div className="bg-[#f8f5ec] border border-[#dfe2d3] border-solid content-stretch flex gap-[11px] items-center overflow-clip p-[10px] relative rounded-[14px] shrink-0 w-full" data-node-id="4:1046" data-name="Day plan">
              <div className="[word-break:break-word] content-stretch flex flex-col gap-[3px] items-center leading-[normal] overflow-clip relative shrink-0 w-[32px] whitespace-nowrap" data-node-id="4:1047" data-name="Day">
                <p className="font-['Inter:Bold'] font-bold not-italic relative shrink-0 text-[#73796b] text-[9px]" data-node-id="4:1048">
                  SAT
                </p>
                <p className="font-['Fraunces:Regular'] font-normal relative shrink-0 text-[#263b2e] text-[23px]" data-node-id="4:1049" style={{ fontVariationSettings: '"SOFT" 0, "WONK" 1' }}>
                  24
                </p>
              </div>
              <div className="h-[49px] relative rounded-[10px] shrink-0 w-[47px]" data-node-id="4:1050" data-name="Recipe photography">
                <img alt="" className="absolute inset-0 max-w-none object-cover pointer-events-none rounded-[10px] size-full" src={imgRecipePhotography5} />
              </div>
              <div className="[word-break:break-word] content-stretch flex flex-[1_0_0] flex-col gap-[5px] items-start min-w-px not-italic overflow-clip relative" data-node-id="4:1051" data-name="Meal">
                <p className="font-['Inter:Semi_Bold'] font-semibold leading-[normal] relative shrink-0 text-[#263b2e] text-[12px] w-full" data-node-id="4:1052">
                  Turkey meatball orzo
                </p>
                <p className="font-['Inter:Regular'] font-normal leading-[1.45] relative shrink-0 text-[#73796b] text-[10px] w-full" data-node-id="4:1053">
                  35 min · Serves 4
                </p>
              </div>
              <div className="relative shrink-0 size-[16px]" data-node-id="4:1054" data-name="arrow-left-right">
                <img alt="" className="absolute block inset-0 max-w-none size-full" src={imgArrowLeftRight} />
              </div>
            </div>
            <div className="bg-[#f8f5ec] border border-[#dfe2d3] border-solid content-stretch flex gap-[11px] items-center overflow-clip p-[10px] relative rounded-[14px] shrink-0 w-full" data-node-id="4:1056" data-name="Day plan">
              <div className="[word-break:break-word] content-stretch flex flex-col gap-[3px] items-center leading-[normal] overflow-clip relative shrink-0 w-[32px] whitespace-nowrap" data-node-id="4:1057" data-name="Day">
                <p className="font-['Inter:Bold'] font-bold not-italic relative shrink-0 text-[#73796b] text-[9px]" data-node-id="4:1058">
                  SUN
                </p>
                <p className="font-['Fraunces:Regular'] font-normal relative shrink-0 text-[#263b2e] text-[23px]" data-node-id="4:1059" style={{ fontVariationSettings: '"SOFT" 0, "WONK" 1' }}>
                  25
                </p>
              </div>
              <div className="h-[49px] relative rounded-[10px] shrink-0 w-[47px]" data-node-id="4:1060" data-name="Recipe photography">
                <img alt="" className="absolute inset-0 max-w-none object-cover pointer-events-none rounded-[10px] size-full" src={imgRecipePhotography6} />
              </div>
              <div className="[word-break:break-word] content-stretch flex flex-[1_0_0] flex-col gap-[5px] items-start min-w-px not-italic overflow-clip relative" data-node-id="4:1061" data-name="Meal">
                <p className="font-['Inter:Semi_Bold'] font-semibold leading-[normal] relative shrink-0 text-[#263b2e] text-[12px] w-full" data-node-id="4:1062">
                  Leftover chicken soup
                </p>
                <p className="font-['Inter:Regular'] font-normal leading-[1.45] relative shrink-0 text-[#73796b] text-[10px] w-full" data-node-id="4:1063">
                  20 min · Use-it-up night
                </p>
              </div>
              <div className="relative shrink-0 size-[16px]" data-node-id="4:1064" data-name="arrow-left-right">
                <img alt="" className="absolute block inset-0 max-w-none size-full" src={imgArrowLeftRight} />
              </div>
            </div>
            <div className="bg-[#f0f1e7] content-stretch flex gap-[9px] items-center overflow-clip p-[12px] relative rounded-[10px] shrink-0 w-full" data-node-id="4:1066" data-name="Other meals summary">
              <div className="relative shrink-0 size-[18px]" data-node-id="4:1067" data-name="sun">
                <img alt="" className="absolute block inset-0 max-w-none size-full" src={imgSun} />
              </div>
              <div className="[word-break:break-word] flex-[1_0_0] font-['Inter:Regular'] font-normal leading-[0] min-w-px not-italic relative text-[#73796b] text-[11px]" data-node-id="4:1069">
                <p className="leading-[1.45] mb-0">Breakfast: overnight oats · Lunch: leftovers</p>
                <p className="leading-[1.45]">Same simple rhythm, less food waste.</p>
              </div>
            </div>
          </div>
          <div className="content-stretch flex flex-col gap-[12px] items-start overflow-clip relative shrink-0 w-full" data-node-id="4:1070" data-name="Plan actions">
            <div className="[word-break:break-word] content-stretch flex items-start justify-between leading-[normal] not-italic overflow-clip relative shrink-0 w-full whitespace-nowrap" data-node-id="4:1071" data-name="Budget summary">
              <p className="font-['Inter:Regular'] font-normal relative shrink-0 text-[#73796b] text-[12px]" data-node-id="4:1072">
                Estimated groceries
              </p>
              <p className="font-['Inter:Semi_Bold'] font-semibold relative shrink-0 text-[#386347] text-[13px]" data-node-id="4:1073">
                £68 of £75 budget
              </p>
            </div>
            <div className="bg-[#386347] border border-[#386347] border-solid content-stretch flex gap-[10px] h-[52px] items-center justify-center overflow-clip relative rounded-[100px] shrink-0 w-full" data-node-id="4:1074" data-name="Button">
              <div className="relative shrink-0 size-[18px]" data-node-id="4:1075" data-name="shopping-basket">
                <img alt="" className="absolute block inset-0 max-w-none size-full" src={imgShoppingBasket} />
              </div>
              <p className="[word-break:break-word] font-['Inter:Semi_Bold'] font-semibold leading-[normal] not-italic relative shrink-0 text-[14px] text-white whitespace-nowrap" data-node-id="4:1077">
                View shopping list · 18 items
              </p>
            </div>
            <div className="content-stretch flex gap-[7px] items-start justify-center overflow-clip relative shrink-0 w-full" data-node-id="4:1078" data-name="Regenerate action">
              <div className="relative shrink-0 size-[14px]" data-node-id="4:1079" data-name="refresh-cw">
                <img alt="" className="absolute block inset-0 max-w-none size-full" src={imgRefreshCw} />
              </div>
              <p className="[word-break:break-word] font-['Inter:Semi_Bold'] font-semibold leading-[normal] not-italic relative shrink-0 text-[#386347] text-[12px] whitespace-nowrap" data-node-id="4:1081">
                Regenerate this week
              </p>
            </div>
          </div>
        </div>
      </div>
      <div className="bg-[#fffef8] border-[#dfe2d3] border-solid border-t content-stretch flex flex-col gap-[12px] items-center overflow-clip pb-[8px] pt-[10px] px-[15px] relative shrink-0 w-full" data-node-id="4:1082" data-name="Bottom navigation">
        <div className="content-stretch flex items-start justify-between overflow-clip relative shrink-0 w-full" data-node-id="4:1083" data-name="Destinations">
          <div className="content-stretch flex flex-col gap-[4px] items-center overflow-clip relative shrink-0 w-[60px]" data-node-id="4:1084" data-name="Navigation item">
            <div className="bg-[#fffef8] content-stretch flex h-[29px] items-center justify-center overflow-clip relative rounded-[100px] shrink-0 w-[48px]" data-node-id="4:1085" data-name="Active indicator">
              <div className="relative shrink-0 size-[21px]" data-node-id="4:1086" data-name="house">
                <img alt="" className="absolute block inset-0 max-w-none size-full" src={imgHouse} />
              </div>
            </div>
            <p className="[word-break:break-word] font-['Inter:Regular'] font-normal leading-[normal] not-italic relative shrink-0 text-[#73796b] text-[10px] whitespace-nowrap" data-node-id="4:1088">
              Home
            </p>
          </div>
          <div className="content-stretch flex flex-col gap-[4px] items-center overflow-clip relative shrink-0 w-[60px]" data-node-id="4:1089" data-name="Navigation item">
            <div className="bg-[#e7eccd] content-stretch flex h-[29px] items-center justify-center overflow-clip relative rounded-[100px] shrink-0 w-[48px]" data-node-id="4:1090" data-name="Active indicator">
              <div className="relative shrink-0 size-[21px]" data-node-id="4:1091" data-name="calendar-days">
                <img alt="" className="absolute block inset-0 max-w-none size-full" src={imgCalendarDays1} />
              </div>
            </div>
            <p className="[word-break:break-word] font-['Inter:Bold'] font-bold leading-[normal] not-italic relative shrink-0 text-[#386347] text-[10px] whitespace-nowrap" data-node-id="4:1093">
              Plan
            </p>
          </div>
          <div className="content-stretch flex flex-col gap-[4px] items-center overflow-clip relative shrink-0 w-[60px]" data-node-id="4:1094" data-name="Navigation item">
            <div className="bg-[#fffef8] content-stretch flex h-[29px] items-center justify-center overflow-clip relative rounded-[100px] shrink-0 w-[48px]" data-node-id="4:1095" data-name="Active indicator">
              <div className="relative shrink-0 size-[21px]" data-node-id="4:1096" data-name="shopping-basket">
                <img alt="" className="absolute block inset-0 max-w-none size-full" src={imgShoppingBasket1} />
              </div>
            </div>
            <p className="[word-break:break-word] font-['Inter:Regular'] font-normal leading-[normal] not-italic relative shrink-0 text-[#73796b] text-[10px] whitespace-nowrap" data-node-id="4:1098">
              Shop
            </p>
          </div>
          <div className="content-stretch flex flex-col gap-[4px] items-center overflow-clip relative shrink-0 w-[60px]" data-node-id="4:1099" data-name="Navigation item">
            <div className="bg-[#fffef8] content-stretch flex h-[29px] items-center justify-center overflow-clip relative rounded-[100px] shrink-0 w-[48px]" data-node-id="4:1100" data-name="Active indicator">
              <div className="relative shrink-0 size-[21px]" data-node-id="4:1101" data-name="book-open">
                <img alt="" className="absolute block inset-0 max-w-none size-full" src={imgBookOpen} />
              </div>
            </div>
            <p className="[word-break:break-word] font-['Inter:Regular'] font-normal leading-[normal] not-italic relative shrink-0 text-[#73796b] text-[10px] whitespace-nowrap" data-node-id="4:1103">
              Recipes
            </p>
          </div>
          <div className="content-stretch flex flex-col gap-[4px] items-center overflow-clip relative shrink-0 w-[60px]" data-node-id="4:1104" data-name="Navigation item">
            <div className="bg-[#fffef8] content-stretch flex h-[29px] items-center justify-center overflow-clip relative rounded-[100px] shrink-0 w-[48px]" data-node-id="4:1105" data-name="Active indicator">
              <div className="relative shrink-0 size-[21px]" data-node-id="4:1106" data-name="users-round">
                <img alt="" className="absolute block inset-0 max-w-none size-full" src={imgUsersRound} />
              </div>
            </div>
            <p className="[word-break:break-word] font-['Inter:Regular'] font-normal leading-[normal] not-italic relative shrink-0 text-[#73796b] text-[10px] whitespace-nowrap" data-node-id="4:1108">
              You
            </p>
          </div>
        </div>
        <div className="bg-[#263b2e] h-[4px] relative rounded-[100px] shrink-0 w-[122px]" data-node-id="4:1109" data-name="Home indicator" />
      </div>
    </div>
  );
}