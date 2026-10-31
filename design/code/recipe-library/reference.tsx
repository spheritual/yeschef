const assetPathPrefix = "assets";
const imgRecipePhotography = `${assetPathPrefix}/recipe-photography.png`;
const imgRecipePhotography1 = `${assetPathPrefix}/recipe-photography1.png`;
const imgRecipePhotography2 = `${assetPathPrefix}/recipe-photography2.png`;
const imgRecipePhotography3 = `${assetPathPrefix}/recipe-photography3.png`;
const imgRecipePhotography4 = `${assetPathPrefix}/recipe-photography4.png`;
const imgIosSignal = `${assetPathPrefix}/ios-signal.svg`;
const imgIosWifiSignal = `${assetPathPrefix}/ios-wifi-signal.svg`;
const imgIosBatteryFull = `${assetPathPrefix}/ios-battery-full.svg`;
const imgBasilTheChef = `${assetPathPrefix}/basil-the-chef.svg`;
const imgPlus = `${assetPathPrefix}/plus.svg`;
const imgPlay = `${assetPathPrefix}/play.svg`;
const imgChevronRight = `${assetPathPrefix}/chevron-right.svg`;
const imgSearch = `${assetPathPrefix}/search.svg`;
const imgHistory = `${assetPathPrefix}/history.svg`;
const imgStar = `${assetPathPrefix}/star.svg`;
const imgChevronRight1 = `${assetPathPrefix}/chevron-right1.svg`;
const imgHouse = `${assetPathPrefix}/house.svg`;
const imgCalendarDays = `${assetPathPrefix}/calendar-days.svg`;
const imgShoppingBasket = `${assetPathPrefix}/shopping-basket.svg`;
const imgBookOpen = `${assetPathPrefix}/book-open.svg`;
const imgUsersRound = `${assetPathPrefix}/users-round.svg`;

export default function RecipeLibrary() {
  return (
    <div className="bg-[#f8f5ec] content-stretch flex flex-col items-start overflow-clip relative rounded-[32px] size-full" data-node-id="4:648" data-name="Recipe library">
      <div className="content-stretch flex h-[50px] items-center justify-between overflow-clip px-[28px] relative shrink-0 w-full" data-node-id="4:649" data-name="Status bar">
        <p className="[word-break:break-word] font-['Inter:Semi_Bold'] font-semibold leading-[normal] not-italic relative shrink-0 text-[#263b2e] text-[14px] whitespace-nowrap" data-node-id="4:650">
          9:41
        </p>
        <div className="content-stretch flex gap-[5px] items-center overflow-clip relative shrink-0" data-node-id="4:651" data-name="Device status">
          <div className="relative shrink-0 size-[17px]" data-node-id="4:652" data-name="ios-signal">
            <img alt="" className="absolute block inset-0 max-w-none size-full" src={imgIosSignal} />
          </div>
          <div className="relative shrink-0 size-[17px]" data-node-id="4:654" data-name="ios-wifi-signal">
            <img alt="" className="absolute block inset-0 max-w-none size-full" src={imgIosWifiSignal} />
          </div>
          <div className="h-[17px] relative shrink-0 w-[24px]" data-node-id="4:656" data-name="ios-battery-full">
            <img alt="" className="absolute block inset-0 max-w-none size-full" src={imgIosBatteryFull} />
          </div>
        </div>
      </div>
      <div className="bg-[#e7eccd] h-[173px] overflow-clip relative shrink-0 w-full" data-node-id="6:276" data-name="Chef header">
        <div className="absolute h-[153px] left-[133px] top-[10px] w-[136px]" data-node-id="6:121" data-name="Basil the chef">
          <img alt="" className="absolute block inset-0 max-w-none size-full" src={imgBasilTheChef} />
        </div>
      </div>
      <div className="content-stretch flex flex-col gap-[24px] items-start min-h-[846px] overflow-clip pb-[24px] pt-[14px] px-[24px] relative shrink-0 w-full" data-node-id="4:658" data-name="Page content">
        <div className="content-stretch flex flex-col gap-[12px] items-start overflow-clip relative shrink-0 w-full" data-node-id="4:659" data-name="Page heading">
          <div className="content-stretch flex gap-[12px] items-center overflow-clip relative shrink-0 w-full" data-node-id="4:660" data-name="Heading row">
            <div className="[word-break:break-word] content-stretch flex flex-[1_0_0] flex-col gap-[5px] items-start min-w-px overflow-clip relative" data-node-id="4:661" data-name="Heading copy">
              <p className="font-['Fraunces:SemiBold'] font-semibold leading-[1.15] relative shrink-0 text-[#263b2e] text-[29px] tracking-[-0.7px] w-full" data-node-id="4:662" style={{ fontVariationSettings: '"SOFT" 0, "WONK" 1' }}>
                Your recipe shelf
              </p>
              <p className="font-['Inter:Regular'] font-normal leading-[1.45] not-italic relative shrink-0 text-[#73796b] text-[12px] w-full" data-node-id="4:663">
                Good things, worth making again.
              </p>
            </div>
            <div className="bg-[#fffef8] border border-[#dfe2d3] border-solid content-stretch flex items-center justify-center overflow-clip relative rounded-[100px] shrink-0 size-[38px]" data-node-id="4:664" data-name="Header action">
              <div className="relative shrink-0 size-[18px]" data-node-id="4:665" data-name="plus">
                <img alt="" className="absolute block inset-0 max-w-none size-full" src={imgPlus} />
              </div>
            </div>
          </div>
          <div className="bg-[#fffef8] border border-[#dfe2d3] border-solid content-stretch flex gap-[10px] items-center overflow-clip px-[14px] py-[12px] relative rounded-[16px] shrink-0 w-full" data-node-id="19:1178" data-name="Learn entry point">
            <div className="bg-[#e7eccd] content-stretch flex items-center justify-center overflow-clip relative rounded-[100px] shrink-0 size-[32px]" data-node-id="19:1179" data-name="Play video">
              <div className="relative shrink-0 size-[15px]" data-node-id="19:1180" data-name="play">
                <img alt="" className="absolute block inset-0 max-w-none size-full" src={imgPlay} />
              </div>
            </div>
            <div className="[word-break:break-word] content-stretch flex flex-[1_0_0] flex-col gap-[2px] items-start min-w-px overflow-clip relative" data-node-id="19:1182" data-name="Learn copy">
              <p className="font-['Inter:Bold'] font-bold leading-[normal] not-italic relative shrink-0 text-[#386347] text-[9px] tracking-[0.7px] whitespace-nowrap" data-node-id="19:1183">
                LEARNING
              </p>
              <p className="font-['Fraunces:SemiBold'] font-semibold leading-[1.15] min-w-full relative shrink-0 text-[#263b2e] text-[18px] w-[min-content]" data-node-id="19:1184" style={{ fontVariationSettings: '"SOFT" 0, "WONK" 1' }}>
                Learn techniques with Basil
              </p>
              <p className="font-['Inter:Regular'] font-normal leading-[1.45] min-w-full not-italic relative shrink-0 text-[#73796b] text-[11px] w-[min-content]" data-node-id="19:1185">
                Short videos for knife skills, heat, prep, and more.
              </p>
            </div>
            <div className="relative shrink-0 size-[17px]" data-node-id="19:1186" data-name="chevron-right">
              <img alt="" className="absolute block inset-0 max-w-none size-full" src={imgChevronRight} />
            </div>
          </div>
        </div>
        <div className="content-stretch flex flex-col gap-[12px] items-start overflow-clip relative shrink-0 w-full" data-node-id="4:667" data-name="Find recipes">
          <div className="bg-[#fffef8] border border-[#dfe2d3] border-solid content-stretch flex gap-[10px] h-[47px] items-center overflow-clip px-[14px] relative rounded-[10px] shrink-0 w-full" data-node-id="4:668" data-name="Search">
            <div className="relative shrink-0 size-[18px]" data-node-id="4:669" data-name="search">
              <img alt="" className="absolute block inset-0 max-w-none size-full" src={imgSearch} />
            </div>
            <p className="[word-break:break-word] flex-[1_0_0] font-['Inter:Regular'] font-normal leading-[1.45] min-w-px not-italic relative text-[#73796b] text-[12px]" data-node-id="4:671">
              Search recipes or ingredients
            </p>
          </div>
          <div className="content-stretch flex gap-[7px] items-start overflow-clip relative shrink-0 w-full" data-node-id="4:672" data-name="Library tabs">
            <div className="bg-[#386347] content-stretch flex items-center overflow-clip px-[12px] py-[8px] relative rounded-[100px] shrink-0" data-node-id="4:673" data-name="Chip">
              <p className="[word-break:break-word] font-['Inter:Semi_Bold'] font-semibold leading-[normal] not-italic relative shrink-0 text-[11px] text-white whitespace-nowrap" data-node-id="4:674">
                Saved · 24
              </p>
            </div>
            <div className="bg-[#f0f1e7] content-stretch flex gap-[5px] items-center overflow-clip px-[12px] py-[8px] relative rounded-[100px] shrink-0" data-node-id="4:675" data-name="Chip">
              <div className="relative shrink-0 size-[13px]" data-node-id="4:676" data-name="history">
                <img alt="" className="absolute block inset-0 max-w-none size-full" src={imgHistory} />
              </div>
              <p className="[word-break:break-word] font-['Inter:Semi_Bold'] font-semibold leading-[normal] not-italic relative shrink-0 text-[#386347] text-[11px] whitespace-nowrap" data-node-id="4:678">
                History
              </p>
            </div>
            <div className="bg-[#f0f1e7] content-stretch flex gap-[5px] items-center overflow-clip px-[12px] py-[8px] relative rounded-[100px] shrink-0" data-node-id="4:679" data-name="Chip">
              <div className="relative shrink-0 size-[13px]" data-node-id="4:680" data-name="star">
                <img alt="" className="absolute block inset-0 max-w-none size-full" src={imgStar} />
              </div>
              <p className="[word-break:break-word] font-['Inter:Semi_Bold'] font-semibold leading-[normal] not-italic relative shrink-0 text-[#386347] text-[11px] whitespace-nowrap" data-node-id="4:682">
                My ratings
              </p>
            </div>
          </div>
        </div>
        <div className="content-stretch flex flex-col gap-[12px] items-start overflow-clip relative shrink-0 w-full" data-node-id="4:683" data-name="Cooking history">
          <div className="[word-break:break-word] content-stretch flex font-semibold items-center justify-between leading-[normal] overflow-clip relative shrink-0 w-full whitespace-nowrap" data-node-id="4:684" data-name="Section heading">
            <p className="font-['Fraunces:SemiBold'] relative shrink-0 text-[#263b2e] text-[21px]" data-node-id="4:685" style={{ fontVariationSettings: '"SOFT" 0, "WONK" 1' }}>{`Made & loved`}</p>
            <p className="font-['Inter:Semi_Bold'] not-italic relative shrink-0 text-[#386347] text-[11px]" data-node-id="4:686">
              All history →
            </p>
          </div>
          <div className="bg-[#e7eccd] content-stretch flex gap-[12px] items-center overflow-clip p-[11px] relative rounded-[20px] shrink-0 w-full" data-node-id="4:687" data-name="Recently cooked recipe">
            <div className="h-[57px] relative rounded-[10px] shrink-0 w-[56px]" data-node-id="4:688" data-name="Recipe photography">
              <img alt="" className="absolute inset-0 max-w-none object-cover pointer-events-none rounded-[10px] size-full" src={imgRecipePhotography} />
            </div>
            <div className="[word-break:break-word] content-stretch flex flex-[1_0_0] flex-col gap-[4px] items-start min-w-px not-italic overflow-clip relative" data-node-id="4:689" data-name="History entry">
              <p className="font-['Inter:Semi_Bold'] font-semibold leading-[1.45] min-w-full relative shrink-0 text-[#263b2e] text-[12px] w-[min-content]" data-node-id="4:690">
                Creamy spinach orzo
              </p>
              <p className="font-['Inter:Regular'] font-normal leading-[1.45] min-w-full relative shrink-0 text-[#73796b] text-[10px] w-[min-content]" data-node-id="4:691">
                Cooked 16 Oct · You rated it
              </p>
              <p className="font-['Inter:Regular'] font-normal leading-[normal] relative shrink-0 text-[#bc5039] text-[12px] tracking-[2px] whitespace-nowrap" data-node-id="4:692">
                ★★★★★
              </p>
            </div>
            <div className="relative shrink-0 size-[17px]" data-node-id="4:693" data-name="chevron-right">
              <img alt="" className="absolute block inset-0 max-w-none size-full" src={imgChevronRight1} />
            </div>
          </div>
        </div>
        <div className="content-stretch flex flex-col gap-[12px] items-start overflow-clip relative shrink-0 w-full" data-node-id="4:695" data-name="Saved recipes">
          <div className="[word-break:break-word] content-stretch flex font-semibold items-center justify-between leading-[normal] overflow-clip relative shrink-0 w-full whitespace-nowrap" data-node-id="4:696" data-name="Section heading">
            <p className="font-['Fraunces:SemiBold'] relative shrink-0 text-[#263b2e] text-[21px]" data-node-id="4:697" style={{ fontVariationSettings: '"SOFT" 0, "WONK" 1' }}>
              The family favourites
            </p>
            <p className="font-['Inter:Semi_Bold'] not-italic relative shrink-0 text-[#386347] text-[11px]" data-node-id="4:698">
              Filter ☷
            </p>
          </div>
          <div className="content-stretch flex gap-[7px] items-start overflow-clip relative shrink-0 w-full" data-node-id="4:699" data-name="Recipe filters">
            <div className="bg-[#386347] content-stretch flex items-center overflow-clip px-[12px] py-[8px] relative rounded-[100px] shrink-0" data-node-id="4:700" data-name="Chip">
              <p className="[word-break:break-word] font-['Inter:Semi_Bold'] font-semibold leading-[normal] not-italic relative shrink-0 text-[11px] text-white whitespace-nowrap" data-node-id="4:701">
                All recipes
              </p>
            </div>
            <div className="bg-[#f0f1e7] content-stretch flex items-center overflow-clip px-[12px] py-[8px] relative rounded-[100px] shrink-0" data-node-id="4:702" data-name="Chip">
              <p className="[word-break:break-word] font-['Inter:Semi_Bold'] font-semibold leading-[normal] not-italic relative shrink-0 text-[#386347] text-[11px] whitespace-nowrap" data-node-id="4:703">
                Vegetarian
              </p>
            </div>
            <div className="bg-[#f0f1e7] content-stretch flex items-center overflow-clip px-[12px] py-[8px] relative rounded-[100px] shrink-0" data-node-id="4:704" data-name="Chip">
              <p className="[word-break:break-word] font-['Inter:Semi_Bold'] font-semibold leading-[normal] not-italic relative shrink-0 text-[#386347] text-[11px] whitespace-nowrap" data-node-id="4:705">
                Under 30 min
              </p>
            </div>
          </div>
          <div className="content-stretch flex gap-[12px] items-start overflow-clip relative shrink-0 w-full" data-node-id="4:706" data-name="Recipe row">
            <div className="bg-[#fffef8] border border-[#dfe2d3] border-solid content-stretch flex flex-[1_0_0] flex-col items-start min-w-px overflow-clip relative rounded-[15px] self-stretch" data-node-id="4:707" data-name="Recipe card">
              <div className="h-[109px] relative shrink-0 w-full" data-node-id="4:708" data-name="Recipe photography">
                <img alt="" className="absolute inset-0 max-w-none object-cover pointer-events-none size-full" src={imgRecipePhotography1} />
              </div>
              <div className="[word-break:break-word] content-stretch flex flex-col gap-[7px] items-start overflow-clip p-[11px] relative shrink-0 w-full" data-node-id="4:709" data-name="Recipe information">
                <p className="font-['Inter:Semi_Bold'] font-semibold leading-[normal] not-italic relative shrink-0 text-[#386347] text-[9px] whitespace-nowrap" data-node-id="4:710">{`ON THIS WEEK'S PLAN`}</p>
                <p className="font-['Fraunces:SemiBold'] font-semibold leading-[1.14] min-w-full relative shrink-0 text-[#263b2e] text-[18px] w-[min-content]" data-node-id="4:711" style={{ fontVariationSettings: '"SOFT" 0, "WONK" 1' }}>{`Lemon & herb salmon`}</p>
                <div className="content-stretch flex items-start justify-between leading-[normal] not-italic overflow-clip relative shrink-0 text-[10px] w-full whitespace-nowrap" data-node-id="4:712" data-name="Metadata">
                  <p className="font-['Inter:Regular'] font-normal relative shrink-0 text-[#73796b]" data-node-id="4:713">
                    30 min
                  </p>
                  <p className="font-['Inter:Semi_Bold'] font-semibold relative shrink-0 text-[#bc5039]" data-node-id="4:714">
                    ★ 4.9
                  </p>
                </div>
              </div>
            </div>
            <div className="bg-[#fffef8] border border-[#dfe2d3] border-solid content-stretch flex flex-[1_0_0] flex-col items-start min-w-px overflow-clip relative rounded-[15px] self-stretch" data-node-id="4:715" data-name="Recipe card">
              <div className="h-[109px] relative shrink-0 w-full" data-node-id="4:716" data-name="Recipe photography">
                <img alt="" className="absolute inset-0 max-w-none object-cover pointer-events-none size-full" src={imgRecipePhotography2} />
              </div>
              <div className="[word-break:break-word] content-stretch flex flex-col gap-[7px] items-start overflow-clip p-[11px] relative shrink-0 w-full" data-node-id="4:717" data-name="Recipe information">
                <p className="font-['Inter:Semi_Bold'] font-semibold leading-[normal] not-italic relative shrink-0 text-[#386347] text-[9px] whitespace-nowrap" data-node-id="4:718">
                  VEGETARIAN
                </p>
                <p className="font-['Fraunces:SemiBold'] font-semibold leading-[1.14] min-w-full relative shrink-0 text-[#263b2e] text-[18px] w-[min-content]" data-node-id="4:719" style={{ fontVariationSettings: '"SOFT" 0, "WONK" 1' }}>
                  Creamy spinach orzo
                </p>
                <div className="content-stretch flex items-start justify-between leading-[normal] not-italic overflow-clip relative shrink-0 text-[10px] w-full whitespace-nowrap" data-node-id="4:720" data-name="Metadata">
                  <p className="font-['Inter:Regular'] font-normal relative shrink-0 text-[#73796b]" data-node-id="4:721">
                    25 min
                  </p>
                  <p className="font-['Inter:Semi_Bold'] font-semibold relative shrink-0 text-[#bc5039]" data-node-id="4:722">
                    ★ 4.8
                  </p>
                </div>
              </div>
            </div>
          </div>
          <div className="content-stretch flex gap-[12px] items-start overflow-clip relative shrink-0 w-full" data-node-id="4:723" data-name="Recipe row">
            <div className="bg-[#fffef8] border border-[#dfe2d3] border-solid content-stretch flex flex-[1_0_0] flex-col items-start min-w-px overflow-clip relative rounded-[15px] self-stretch" data-node-id="4:724" data-name="Recipe card">
              <div className="h-[109px] relative shrink-0 w-full" data-node-id="4:725" data-name="Recipe photography">
                <img alt="" className="absolute inset-0 max-w-none object-cover pointer-events-none size-full" src={imgRecipePhotography3} />
              </div>
              <div className="[word-break:break-word] content-stretch flex flex-col gap-[7px] items-start overflow-clip p-[11px] relative shrink-0 w-full" data-node-id="4:726" data-name="Recipe information">
                <p className="font-['Inter:Semi_Bold'] font-semibold leading-[normal] not-italic relative shrink-0 text-[#386347] text-[9px] whitespace-nowrap" data-node-id="4:727">
                  VEGETARIAN
                </p>
                <p className="font-['Fraunces:SemiBold'] font-semibold leading-[1.14] min-w-full relative shrink-0 text-[#263b2e] text-[18px] w-[min-content]" data-node-id="4:728" style={{ fontVariationSettings: '"SOFT" 0, "WONK" 1' }}>
                  Sweet potato tacos
                </p>
                <div className="content-stretch flex items-start justify-between leading-[normal] not-italic overflow-clip relative shrink-0 text-[10px] w-full whitespace-nowrap" data-node-id="4:729" data-name="Metadata">
                  <p className="font-['Inter:Regular'] font-normal relative shrink-0 text-[#73796b]" data-node-id="4:730">
                    25 min
                  </p>
                  <p className="font-['Inter:Semi_Bold'] font-semibold relative shrink-0 text-[#bc5039]" data-node-id="4:731">
                    ★ 4.9
                  </p>
                </div>
              </div>
            </div>
            <div className="bg-[#fffef8] border border-[#dfe2d3] border-solid content-stretch flex flex-[1_0_0] flex-col items-start min-w-px overflow-clip relative rounded-[15px] self-stretch" data-node-id="4:732" data-name="Recipe card">
              <div className="h-[109px] relative shrink-0 w-full" data-node-id="4:733" data-name="Recipe photography">
                <img alt="" className="absolute inset-0 max-w-none object-cover pointer-events-none size-full" src={imgRecipePhotography4} />
              </div>
              <div className="[word-break:break-word] content-stretch flex flex-col gap-[7px] items-start overflow-clip p-[11px] relative shrink-0 w-full" data-node-id="4:734" data-name="Recipe information">
                <p className="font-['Inter:Semi_Bold'] font-semibold leading-[normal] not-italic relative shrink-0 text-[#386347] text-[9px] whitespace-nowrap" data-node-id="4:735">
                  BATCH-COOK FRIENDLY
                </p>
                <p className="font-['Fraunces:SemiBold'] font-semibold leading-[1.14] min-w-full relative shrink-0 text-[#263b2e] text-[18px] w-[min-content]" data-node-id="4:736" style={{ fontVariationSettings: '"SOFT" 0, "WONK" 1' }}>
                  Coconut chickpea curry
                </p>
                <div className="content-stretch flex items-start justify-between leading-[normal] not-italic overflow-clip relative shrink-0 text-[10px] w-full whitespace-nowrap" data-node-id="4:737" data-name="Metadata">
                  <p className="font-['Inter:Regular'] font-normal relative shrink-0 text-[#73796b]" data-node-id="4:738">
                    30 min
                  </p>
                  <p className="font-['Inter:Semi_Bold'] font-semibold relative shrink-0 text-[#bc5039]" data-node-id="4:739">
                    ★ 4.7
                  </p>
                </div>
              </div>
            </div>
          </div>
        </div>
        <p className="[word-break:break-word] font-['Inter:Regular'] font-normal leading-[1.45] not-italic relative shrink-0 text-[#73796b] text-[11px] text-center w-full" data-node-id="4:740">{`24 little answers to "what's for dinner?"`}</p>
      </div>
      <div className="bg-[#fffef8] border-[#dfe2d3] border-solid border-t content-stretch flex flex-col gap-[12px] items-center overflow-clip pb-[8px] pt-[10px] px-[15px] relative shrink-0 w-full" data-node-id="4:741" data-name="Bottom navigation">
        <div className="content-stretch flex items-start justify-between overflow-clip relative shrink-0 w-full" data-node-id="4:742" data-name="Destinations">
          <div className="content-stretch flex flex-col gap-[4px] items-center overflow-clip relative shrink-0 w-[60px]" data-node-id="4:743" data-name="Navigation item">
            <div className="bg-[#fffef8] content-stretch flex h-[29px] items-center justify-center overflow-clip relative rounded-[100px] shrink-0 w-[48px]" data-node-id="4:744" data-name="Active indicator">
              <div className="relative shrink-0 size-[21px]" data-node-id="4:745" data-name="house">
                <img alt="" className="absolute block inset-0 max-w-none size-full" src={imgHouse} />
              </div>
            </div>
            <p className="[word-break:break-word] font-['Inter:Regular'] font-normal leading-[normal] not-italic relative shrink-0 text-[#73796b] text-[10px] whitespace-nowrap" data-node-id="4:747">
              Home
            </p>
          </div>
          <div className="content-stretch flex flex-col gap-[4px] items-center overflow-clip relative shrink-0 w-[60px]" data-node-id="4:748" data-name="Navigation item">
            <div className="bg-[#fffef8] content-stretch flex h-[29px] items-center justify-center overflow-clip relative rounded-[100px] shrink-0 w-[48px]" data-node-id="4:749" data-name="Active indicator">
              <div className="relative shrink-0 size-[21px]" data-node-id="4:750" data-name="calendar-days">
                <img alt="" className="absolute block inset-0 max-w-none size-full" src={imgCalendarDays} />
              </div>
            </div>
            <p className="[word-break:break-word] font-['Inter:Regular'] font-normal leading-[normal] not-italic relative shrink-0 text-[#73796b] text-[10px] whitespace-nowrap" data-node-id="4:752">
              Plan
            </p>
          </div>
          <div className="content-stretch flex flex-col gap-[4px] items-center overflow-clip relative shrink-0 w-[60px]" data-node-id="4:753" data-name="Navigation item">
            <div className="bg-[#fffef8] content-stretch flex h-[29px] items-center justify-center overflow-clip relative rounded-[100px] shrink-0 w-[48px]" data-node-id="4:754" data-name="Active indicator">
              <div className="relative shrink-0 size-[21px]" data-node-id="4:755" data-name="shopping-basket">
                <img alt="" className="absolute block inset-0 max-w-none size-full" src={imgShoppingBasket} />
              </div>
            </div>
            <p className="[word-break:break-word] font-['Inter:Regular'] font-normal leading-[normal] not-italic relative shrink-0 text-[#73796b] text-[10px] whitespace-nowrap" data-node-id="4:757">
              Shop
            </p>
          </div>
          <div className="content-stretch flex flex-col gap-[4px] items-center overflow-clip relative shrink-0 w-[60px]" data-node-id="4:758" data-name="Navigation item">
            <div className="bg-[#e7eccd] content-stretch flex h-[29px] items-center justify-center overflow-clip relative rounded-[100px] shrink-0 w-[48px]" data-node-id="4:759" data-name="Active indicator">
              <div className="relative shrink-0 size-[21px]" data-node-id="4:760" data-name="book-open">
                <img alt="" className="absolute block inset-0 max-w-none size-full" src={imgBookOpen} />
              </div>
            </div>
            <p className="[word-break:break-word] font-['Inter:Bold'] font-bold leading-[normal] not-italic relative shrink-0 text-[#386347] text-[10px] whitespace-nowrap" data-node-id="4:762">
              Recipes
            </p>
          </div>
          <div className="content-stretch flex flex-col gap-[4px] items-center overflow-clip relative shrink-0 w-[60px]" data-node-id="4:763" data-name="Navigation item">
            <div className="bg-[#fffef8] content-stretch flex h-[29px] items-center justify-center overflow-clip relative rounded-[100px] shrink-0 w-[48px]" data-node-id="4:764" data-name="Active indicator">
              <div className="relative shrink-0 size-[21px]" data-node-id="4:765" data-name="users-round">
                <img alt="" className="absolute block inset-0 max-w-none size-full" src={imgUsersRound} />
              </div>
            </div>
            <p className="[word-break:break-word] font-['Inter:Regular'] font-normal leading-[normal] not-italic relative shrink-0 text-[#73796b] text-[10px] whitespace-nowrap" data-node-id="4:767">
              You
            </p>
          </div>
        </div>
        <div className="bg-[#263b2e] h-[4px] relative rounded-[100px] shrink-0 w-[122px]" data-node-id="4:768" data-name="Home indicator" />
      </div>
    </div>
  );
}