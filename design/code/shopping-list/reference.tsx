const assetPathPrefix = "assets";
const imgIosSignal = `${assetPathPrefix}/ios-signal.svg`;
const imgIosWifiSignal = `${assetPathPrefix}/ios-wifi-signal.svg`;
const imgIosBatteryFull = `${assetPathPrefix}/ios-battery-full.svg`;
const imgBasilTheChef = `${assetPathPrefix}/basil-the-chef.svg`;
const imgShare2 = `${assetPathPrefix}/share2.svg`;
const imgCarrot = `${assetPathPrefix}/carrot.svg`;
const imgCheck = `${assetPathPrefix}/check.svg`;
const imgSnowflake = `${assetPathPrefix}/snowflake.svg`;
const imgPackage = `${assetPathPrefix}/package.svg`;
const imgPlus = `${assetPathPrefix}/plus.svg`;
const imgLeaf = `${assetPathPrefix}/leaf.svg`;
const imgUsersRound = `${assetPathPrefix}/users-round.svg`;
const imgHouse = `${assetPathPrefix}/house.svg`;
const imgCalendarDays = `${assetPathPrefix}/calendar-days.svg`;
const imgShoppingBasket = `${assetPathPrefix}/shopping-basket.svg`;
const imgBookOpen = `${assetPathPrefix}/book-open.svg`;
const imgUsersRound1 = `${assetPathPrefix}/users-round1.svg`;

export default function WeeklyShoppingList() {
  return (
    <div className="bg-[#f8f5ec] content-stretch flex flex-col items-start overflow-clip relative rounded-[32px] size-full" data-node-id="4:769" data-name="Weekly shopping list">
      <div className="content-stretch flex h-[50px] items-center justify-between overflow-clip px-[28px] relative shrink-0 w-full" data-node-id="4:770" data-name="Status bar">
        <p className="[word-break:break-word] font-['Inter:Semi_Bold'] font-semibold leading-[normal] not-italic relative shrink-0 text-[#263b2e] text-[14px] whitespace-nowrap" data-node-id="4:771">
          9:41
        </p>
        <div className="content-stretch flex gap-[5px] items-center overflow-clip relative shrink-0" data-node-id="4:772" data-name="Device status">
          <div className="relative shrink-0 size-[17px]" data-node-id="4:773" data-name="ios-signal">
            <img alt="" className="absolute block inset-0 max-w-none size-full" src={imgIosSignal} />
          </div>
          <div className="relative shrink-0 size-[17px]" data-node-id="4:775" data-name="ios-wifi-signal">
            <img alt="" className="absolute block inset-0 max-w-none size-full" src={imgIosWifiSignal} />
          </div>
          <div className="h-[17px] relative shrink-0 w-[24px]" data-node-id="4:777" data-name="ios-battery-full">
            <img alt="" className="absolute block inset-0 max-w-none size-full" src={imgIosBatteryFull} />
          </div>
        </div>
      </div>
      <div className="content-stretch flex flex-col items-start min-h-[966px] overflow-clip relative shrink-0 w-full" data-node-id="4:779" data-name="Page content">
        <div className="bg-[#e7eccd] content-stretch flex flex-col h-[173px] items-center overflow-clip relative shrink-0 w-full" data-node-id="6:149" data-name="Chef header">
          <div className="-translate-x-1/2 absolute h-[153px] left-1/2 top-[10px] w-[136px]" data-node-id="6:150" data-name="Basil the chef">
            <img alt="" className="absolute block inset-0 max-w-none size-full" src={imgBasilTheChef} />
          </div>
        </div>
        <div className="content-stretch flex flex-col gap-[24px] items-start overflow-clip pb-[24px] pt-[14px] px-[24px] relative shrink-0 w-full" data-node-id="6:176" data-name="Page content inner">
          <div className="content-stretch flex flex-col items-start overflow-clip relative shrink-0 w-full" data-node-id="4:780" data-name="Page heading">
            <div className="content-stretch flex gap-[12px] items-center overflow-clip relative shrink-0 w-full" data-node-id="4:781" data-name="Heading row">
              <div className="[word-break:break-word] content-stretch flex flex-[1_0_0] flex-col gap-[5px] items-start min-w-px overflow-clip relative" data-node-id="4:782" data-name="Heading copy">
                <p className="font-['Fraunces:SemiBold'] font-semibold leading-[1.15] relative shrink-0 text-[#263b2e] text-[29px] tracking-[-0.7px] w-full" data-node-id="4:783" style={{ fontVariationSettings: '"SOFT" 0, "WONK" 1' }}>
                  The good-food list
                </p>
                <p className="font-['Inter:Regular'] font-normal leading-[1.45] not-italic relative shrink-0 text-[#73796b] text-[12px] w-full" data-node-id="4:784">
                  19 – 25 October · Morgan kitchen
                </p>
              </div>
              <div className="bg-[#fffef8] border border-[#dfe2d3] border-solid content-stretch flex items-center justify-center overflow-clip relative rounded-[100px] shrink-0 size-[38px]" data-node-id="4:785" data-name="Header action">
                <div className="relative shrink-0 size-[18px]" data-node-id="4:786" data-name="share-2">
                  <img alt="" className="absolute block inset-0 max-w-none size-full" src={imgShare2} />
                </div>
              </div>
            </div>
          </div>
          <div className="content-stretch flex flex-col gap-[10px] items-start overflow-clip relative shrink-0 w-full" data-node-id="4:788" data-name="Shopping progress">
            <div className="[word-break:break-word] content-stretch flex font-['Inter:Semi_Bold'] font-semibold items-center justify-between not-italic overflow-clip relative shrink-0 text-[12px] w-full" data-node-id="4:789" data-name="List summary">
              <p className="flex-[1_0_0] leading-[1.45] min-w-px relative text-[#263b2e]" data-node-id="4:790">
                5 of 18 items checked
              </p>
              <p className="leading-[normal] relative shrink-0 text-[#386347] whitespace-nowrap" data-node-id="4:791">
                Est. £68
              </p>
            </div>
            <div className="bg-[#dfe2d3] content-stretch flex h-[5px] items-start overflow-clip relative rounded-[100px] shrink-0 w-full" data-node-id="4:792" data-name="Progress track">
              <div className="bg-[#386347] h-[5px] relative rounded-[100px] shrink-0 w-[98px]" data-node-id="4:793" data-name="Completed progress" />
            </div>
            <div className="content-stretch flex gap-[8px] items-start overflow-clip relative shrink-0 w-full" data-node-id="4:794" data-name="Shopping filters">
              <div className="bg-[#386347] content-stretch flex items-center overflow-clip px-[12px] py-[8px] relative rounded-[100px] shrink-0" data-node-id="4:795" data-name="Chip">
                <p className="[word-break:break-word] font-['Inter:Semi_Bold'] font-semibold leading-[normal] not-italic relative shrink-0 text-[11px] text-white whitespace-nowrap" data-node-id="4:796">
                  By aisle
                </p>
              </div>
              <div className="bg-[#f0f1e7] content-stretch flex items-center overflow-clip px-[12px] py-[8px] relative rounded-[100px] shrink-0" data-node-id="4:797" data-name="Chip">
                <p className="[word-break:break-word] font-['Inter:Semi_Bold'] font-semibold leading-[normal] not-italic relative shrink-0 text-[#386347] text-[11px] whitespace-nowrap" data-node-id="4:798">
                  By recipe
                </p>
              </div>
              <div className="bg-[#f0f1e7] content-stretch flex items-center overflow-clip px-[12px] py-[8px] relative rounded-[100px] shrink-0" data-node-id="4:799" data-name="Chip">
                <p className="[word-break:break-word] font-['Inter:Semi_Bold'] font-semibold leading-[normal] not-italic relative shrink-0 text-[#386347] text-[11px] whitespace-nowrap" data-node-id="4:800">
                  Hide checked
                </p>
              </div>
            </div>
          </div>
          <div className="content-stretch flex flex-col gap-[18px] items-start overflow-clip relative shrink-0 w-full" data-node-id="4:801" data-name="Grouped groceries">
            <div className="content-stretch flex flex-col items-start overflow-clip relative shrink-0 w-full" data-node-id="4:802" data-name="Grocery group">
              <div className="border-[#dfe2d3] border-b border-solid content-stretch flex gap-[7px] items-center overflow-clip pb-[5px] relative shrink-0 w-full" data-node-id="4:803" data-name="Aisle heading">
                <div className="relative shrink-0 size-[17px]" data-node-id="4:804" data-name="carrot">
                  <img alt="" className="absolute block inset-0 max-w-none size-full" src={imgCarrot} />
                </div>
                <p className="[word-break:break-word] flex-[1_0_0] font-['Fraunces:SemiBold'] font-semibold leading-[normal] min-w-px relative text-[#263b2e] text-[18px]" data-node-id="4:806" style={{ fontVariationSettings: '"SOFT" 0, "WONK" 1' }}>{`Fruit & vegetables`}</p>
                <p className="[word-break:break-word] font-['Inter:Regular'] font-normal leading-[normal] not-italic relative shrink-0 text-[#73796b] text-[10px] whitespace-nowrap" data-node-id="4:807">
                  8 items
                </p>
              </div>
              <div className="content-stretch flex gap-[11px] h-[32px] items-center overflow-clip relative shrink-0 w-full" data-node-id="4:808" data-name="Grocery">
                <div className="bg-[#fffef8] border-[#bec4b5] border-[1.3px] border-solid relative rounded-[6px] shrink-0 size-[20px]" data-node-id="4:809" data-name="Checkbox" />
                <p className="[word-break:break-word] flex-[1_0_0] font-['Inter:Regular'] font-normal leading-[normal] min-w-px not-italic relative text-[#263b2e] text-[12px]" data-node-id="4:810">
                  Baby potatoes
                </p>
                <p className="[word-break:break-word] font-['Inter:Regular'] font-normal leading-[normal] not-italic relative shrink-0 text-[#73796b] text-[11px] whitespace-nowrap" data-node-id="4:811">
                  700 g
                </p>
              </div>
              <div className="content-stretch flex gap-[11px] h-[32px] items-center overflow-clip relative shrink-0 w-full" data-node-id="4:812" data-name="Grocery">
                <div className="bg-[#fffef8] border-[#bec4b5] border-[1.3px] border-solid relative rounded-[6px] shrink-0 size-[20px]" data-node-id="4:813" data-name="Checkbox" />
                <p className="[word-break:break-word] flex-[1_0_0] font-['Inter:Regular'] font-normal leading-[normal] min-w-px not-italic relative text-[#263b2e] text-[12px]" data-node-id="4:814">
                  Broccoli
                </p>
                <p className="[word-break:break-word] font-['Inter:Regular'] font-normal leading-[normal] not-italic relative shrink-0 text-[#73796b] text-[11px] whitespace-nowrap" data-node-id="4:815">
                  2 heads
                </p>
              </div>
              <div className="content-stretch flex gap-[11px] h-[32px] items-center overflow-clip relative shrink-0 w-full" data-node-id="4:816" data-name="Grocery">
                <div className="bg-[#fffef8] border-[#bec4b5] border-[1.3px] border-solid relative rounded-[6px] shrink-0 size-[20px]" data-node-id="4:817" data-name="Checkbox" />
                <p className="[word-break:break-word] flex-[1_0_0] font-['Inter:Regular'] font-normal leading-[normal] min-w-px not-italic relative text-[#263b2e] text-[12px]" data-node-id="4:818">
                  Lemons
                </p>
                <p className="[word-break:break-word] font-['Inter:Regular'] font-normal leading-[normal] not-italic relative shrink-0 text-[#73796b] text-[11px] whitespace-nowrap" data-node-id="4:819">
                  2
                </p>
              </div>
              <div className="content-stretch flex gap-[11px] h-[32px] items-center overflow-clip relative shrink-0 w-full" data-node-id="4:820" data-name="Grocery">
                <div className="bg-[#fffef8] border-[#bec4b5] border-[1.3px] border-solid relative rounded-[6px] shrink-0 size-[20px]" data-node-id="4:821" data-name="Checkbox" />
                <p className="[word-break:break-word] flex-[1_0_0] font-['Inter:Regular'] font-normal leading-[normal] min-w-px not-italic relative text-[#263b2e] text-[12px]" data-node-id="4:822">
                  Baby spinach
                </p>
                <p className="[word-break:break-word] font-['Inter:Regular'] font-normal leading-[normal] not-italic relative shrink-0 text-[#73796b] text-[11px] whitespace-nowrap" data-node-id="4:823">
                  250 g
                </p>
              </div>
              <div className="content-stretch flex gap-[11px] h-[32px] items-center overflow-clip relative shrink-0 w-full" data-node-id="4:824" data-name="Grocery">
                <div className="bg-[#fffef8] border-[#bec4b5] border-[1.3px] border-solid relative rounded-[6px] shrink-0 size-[20px]" data-node-id="4:825" data-name="Checkbox" />
                <p className="[word-break:break-word] flex-[1_0_0] font-['Inter:Regular'] font-normal leading-[normal] min-w-px not-italic relative text-[#263b2e] text-[12px]" data-node-id="4:826">
                  Cherry tomatoes
                </p>
                <p className="[word-break:break-word] font-['Inter:Regular'] font-normal leading-[normal] not-italic relative shrink-0 text-[#73796b] text-[11px] whitespace-nowrap" data-node-id="4:827">
                  300 g
                </p>
              </div>
              <div className="content-stretch flex gap-[11px] h-[32px] items-center overflow-clip relative shrink-0 w-full" data-node-id="4:828" data-name="Grocery">
                <div className="bg-[#fffef8] border-[#bec4b5] border-[1.3px] border-solid relative rounded-[6px] shrink-0 size-[20px]" data-node-id="4:829" data-name="Checkbox" />
                <p className="[word-break:break-word] flex-[1_0_0] font-['Inter:Regular'] font-normal leading-[normal] min-w-px not-italic relative text-[#263b2e] text-[12px]" data-node-id="4:830">
                  Sweet potatoes
                </p>
                <p className="[word-break:break-word] font-['Inter:Regular'] font-normal leading-[normal] not-italic relative shrink-0 text-[#73796b] text-[11px] whitespace-nowrap" data-node-id="4:831">
                  600 g
                </p>
              </div>
              <div className="content-stretch flex gap-[11px] h-[32px] items-center overflow-clip relative shrink-0 w-full" data-node-id="4:832" data-name="Grocery">
                <div className="bg-[#fffef8] border-[#bec4b5] border-[1.3px] border-solid relative rounded-[6px] shrink-0 size-[20px]" data-node-id="4:833" data-name="Checkbox" />
                <p className="[word-break:break-word] flex-[1_0_0] font-['Inter:Regular'] font-normal leading-[normal] min-w-px not-italic relative text-[#263b2e] text-[12px]" data-node-id="4:834">
                  Garlic
                </p>
                <p className="[word-break:break-word] font-['Inter:Regular'] font-normal leading-[normal] not-italic relative shrink-0 text-[#73796b] text-[11px] whitespace-nowrap" data-node-id="4:835">
                  1 bulb
                </p>
              </div>
              <div className="content-stretch flex gap-[11px] h-[32px] items-center overflow-clip relative shrink-0 w-full" data-node-id="4:836" data-name="Grocery">
                <div className="bg-[#386347] border-[#386347] border-[1.3px] border-solid content-stretch flex items-center justify-center overflow-clip relative rounded-[6px] shrink-0 size-[20px]" data-node-id="4:837" data-name="Checkbox">
                  <div className="relative shrink-0 size-[13px]" data-node-id="4:838" data-name="check">
                    <img alt="" className="absolute block inset-0 max-w-none size-full" src={imgCheck} />
                  </div>
                </div>
                <p className="[text-decoration-skip-ink:none] [text-underline-position:from-font] [word-break:break-word] decoration-from-font decoration-solid flex-[1_0_0] font-['Inter:Regular'] font-normal leading-[normal] line-through min-w-px not-italic relative text-[#9b9e90] text-[12px]" data-node-id="4:840">
                  Fresh dill
                </p>
                <p className="[word-break:break-word] font-['Inter:Regular'] font-normal leading-[normal] not-italic relative shrink-0 text-[#9b9e90] text-[11px] whitespace-nowrap" data-node-id="4:841">
                  20 g
                </p>
              </div>
            </div>
            <div className="content-stretch flex flex-col items-start overflow-clip relative shrink-0 w-full" data-node-id="4:842" data-name="Grocery group">
              <div className="border-[#dfe2d3] border-b border-solid content-stretch flex gap-[7px] items-center overflow-clip pb-[5px] relative shrink-0 w-full" data-node-id="4:843" data-name="Aisle heading">
                <div className="relative shrink-0 size-[17px]" data-node-id="4:844" data-name="snowflake">
                  <img alt="" className="absolute block inset-0 max-w-none size-full" src={imgSnowflake} />
                </div>
                <p className="[word-break:break-word] flex-[1_0_0] font-['Fraunces:SemiBold'] font-semibold leading-[normal] min-w-px relative text-[#263b2e] text-[18px]" data-node-id="4:846" style={{ fontVariationSettings: '"SOFT" 0, "WONK" 1' }}>{`Chilled & fresh`}</p>
                <p className="[word-break:break-word] font-['Inter:Regular'] font-normal leading-[normal] not-italic relative shrink-0 text-[#73796b] text-[10px] whitespace-nowrap" data-node-id="4:847">
                  4 items
                </p>
              </div>
              <div className="content-stretch flex gap-[11px] h-[32px] items-center overflow-clip relative shrink-0 w-full" data-node-id="4:848" data-name="Grocery">
                <div className="bg-[#fffef8] border-[#bec4b5] border-[1.3px] border-solid relative rounded-[6px] shrink-0 size-[20px]" data-node-id="4:849" data-name="Checkbox" />
                <p className="[word-break:break-word] flex-[1_0_0] font-['Inter:Regular'] font-normal leading-[normal] min-w-px not-italic relative text-[#263b2e] text-[12px]" data-node-id="4:850">
                  Salmon fillets
                </p>
                <p className="[word-break:break-word] font-['Inter:Regular'] font-normal leading-[normal] not-italic relative shrink-0 text-[#73796b] text-[11px] whitespace-nowrap" data-node-id="4:851">
                  4 × 150 g
                </p>
              </div>
              <div className="content-stretch flex gap-[11px] h-[32px] items-center overflow-clip relative shrink-0 w-full" data-node-id="4:852" data-name="Grocery">
                <div className="bg-[#fffef8] border-[#bec4b5] border-[1.3px] border-solid relative rounded-[6px] shrink-0 size-[20px]" data-node-id="4:853" data-name="Checkbox" />
                <p className="[word-break:break-word] flex-[1_0_0] font-['Inter:Regular'] font-normal leading-[normal] min-w-px not-italic relative text-[#263b2e] text-[12px]" data-node-id="4:854">
                  Chicken thighs
                </p>
                <p className="[word-break:break-word] font-['Inter:Regular'] font-normal leading-[normal] not-italic relative shrink-0 text-[#73796b] text-[11px] whitespace-nowrap" data-node-id="4:855">
                  800 g
                </p>
              </div>
              <div className="content-stretch flex gap-[11px] h-[32px] items-center overflow-clip relative shrink-0 w-full" data-node-id="4:856" data-name="Grocery">
                <div className="bg-[#fffef8] border-[#bec4b5] border-[1.3px] border-solid relative rounded-[6px] shrink-0 size-[20px]" data-node-id="4:857" data-name="Checkbox" />
                <p className="[word-break:break-word] flex-[1_0_0] font-['Inter:Regular'] font-normal leading-[normal] min-w-px not-italic relative text-[#263b2e] text-[12px]" data-node-id="4:858">
                  Turkey mince
                </p>
                <p className="[word-break:break-word] font-['Inter:Regular'] font-normal leading-[normal] not-italic relative shrink-0 text-[#73796b] text-[11px] whitespace-nowrap" data-node-id="4:859">
                  500 g
                </p>
              </div>
              <div className="content-stretch flex gap-[11px] h-[32px] items-center overflow-clip relative shrink-0 w-full" data-node-id="4:860" data-name="Grocery">
                <div className="bg-[#fffef8] border-[#bec4b5] border-[1.3px] border-solid relative rounded-[6px] shrink-0 size-[20px]" data-node-id="4:861" data-name="Checkbox" />
                <p className="[word-break:break-word] flex-[1_0_0] font-['Inter:Regular'] font-normal leading-[normal] min-w-px not-italic relative text-[#263b2e] text-[12px]" data-node-id="4:862">
                  Parmesan
                </p>
                <p className="[word-break:break-word] font-['Inter:Regular'] font-normal leading-[normal] not-italic relative shrink-0 text-[#73796b] text-[11px] whitespace-nowrap" data-node-id="4:863">
                  100 g
                </p>
              </div>
            </div>
            <div className="content-stretch flex flex-col items-start overflow-clip relative shrink-0 w-full" data-node-id="4:864" data-name="Grocery group">
              <div className="border-[#dfe2d3] border-b border-solid content-stretch flex gap-[7px] items-center overflow-clip pb-[5px] relative shrink-0 w-full" data-node-id="4:865" data-name="Aisle heading">
                <div className="relative shrink-0 size-[17px]" data-node-id="4:866" data-name="package">
                  <img alt="" className="absolute block inset-0 max-w-none size-full" src={imgPackage} />
                </div>
                <p className="[word-break:break-word] flex-[1_0_0] font-['Fraunces:SemiBold'] font-semibold leading-[normal] min-w-px relative text-[#263b2e] text-[18px]" data-node-id="4:868" style={{ fontVariationSettings: '"SOFT" 0, "WONK" 1' }}>
                  Pantry
                </p>
                <p className="[word-break:break-word] font-['Inter:Regular'] font-normal leading-[normal] not-italic relative shrink-0 text-[#73796b] text-[10px] whitespace-nowrap" data-node-id="4:869">
                  6 items
                </p>
              </div>
              <div className="content-stretch flex gap-[11px] h-[32px] items-center overflow-clip relative shrink-0 w-full" data-node-id="4:870" data-name="Grocery">
                <div className="bg-[#fffef8] border-[#bec4b5] border-[1.3px] border-solid relative rounded-[6px] shrink-0 size-[20px]" data-node-id="4:871" data-name="Checkbox" />
                <p className="[word-break:break-word] flex-[1_0_0] font-['Inter:Regular'] font-normal leading-[normal] min-w-px not-italic relative text-[#263b2e] text-[12px]" data-node-id="4:872">
                  Orzo
                </p>
                <p className="[word-break:break-word] font-['Inter:Regular'] font-normal leading-[normal] not-italic relative shrink-0 text-[#73796b] text-[11px] whitespace-nowrap" data-node-id="4:873">
                  500 g
                </p>
              </div>
              <div className="content-stretch flex gap-[11px] h-[32px] items-center overflow-clip relative shrink-0 w-full" data-node-id="4:874" data-name="Grocery">
                <div className="bg-[#fffef8] border-[#bec4b5] border-[1.3px] border-solid relative rounded-[6px] shrink-0 size-[20px]" data-node-id="4:875" data-name="Checkbox" />
                <p className="[word-break:break-word] flex-[1_0_0] font-['Inter:Regular'] font-normal leading-[normal] min-w-px not-italic relative text-[#263b2e] text-[12px]" data-node-id="4:876">
                  Black beans
                </p>
                <p className="[word-break:break-word] font-['Inter:Regular'] font-normal leading-[normal] not-italic relative shrink-0 text-[#73796b] text-[11px] whitespace-nowrap" data-node-id="4:877">
                  400 g tin
                </p>
              </div>
              <div className="content-stretch flex gap-[11px] h-[32px] items-center overflow-clip relative shrink-0 w-full" data-node-id="4:878" data-name="Grocery">
                <div className="bg-[#386347] border-[#386347] border-[1.3px] border-solid content-stretch flex items-center justify-center overflow-clip relative rounded-[6px] shrink-0 size-[20px]" data-node-id="4:879" data-name="Checkbox">
                  <div className="relative shrink-0 size-[13px]" data-node-id="4:880" data-name="check">
                    <img alt="" className="absolute block inset-0 max-w-none size-full" src={imgCheck} />
                  </div>
                </div>
                <p className="[text-decoration-skip-ink:none] [text-underline-position:from-font] [word-break:break-word] decoration-from-font decoration-solid flex-[1_0_0] font-['Inter:Regular'] font-normal leading-[normal] line-through min-w-px not-italic relative text-[#9b9e90] text-[12px]" data-node-id="4:882">
                  Chickpeas
                </p>
                <p className="[word-break:break-word] font-['Inter:Regular'] font-normal leading-[normal] not-italic relative shrink-0 text-[#9b9e90] text-[11px] whitespace-nowrap" data-node-id="4:883">
                  400 g tin
                </p>
              </div>
              <div className="content-stretch flex gap-[11px] h-[32px] items-center overflow-clip relative shrink-0 w-full" data-node-id="4:884" data-name="Grocery">
                <div className="bg-[#386347] border-[#386347] border-[1.3px] border-solid content-stretch flex items-center justify-center overflow-clip relative rounded-[6px] shrink-0 size-[20px]" data-node-id="4:885" data-name="Checkbox">
                  <div className="relative shrink-0 size-[13px]" data-node-id="4:886" data-name="check">
                    <img alt="" className="absolute block inset-0 max-w-none size-full" src={imgCheck} />
                  </div>
                </div>
                <p className="[text-decoration-skip-ink:none] [text-underline-position:from-font] [word-break:break-word] decoration-from-font decoration-solid flex-[1_0_0] font-['Inter:Regular'] font-normal leading-[normal] line-through min-w-px not-italic relative text-[#9b9e90] text-[12px]" data-node-id="4:888">
                  Corn tortillas
                </p>
                <p className="[word-break:break-word] font-['Inter:Regular'] font-normal leading-[normal] not-italic relative shrink-0 text-[#9b9e90] text-[11px] whitespace-nowrap" data-node-id="4:889">
                  12 pack
                </p>
              </div>
              <div className="content-stretch flex gap-[11px] h-[32px] items-center overflow-clip relative shrink-0 w-full" data-node-id="4:890" data-name="Grocery">
                <div className="bg-[#386347] border-[#386347] border-[1.3px] border-solid content-stretch flex items-center justify-center overflow-clip relative rounded-[6px] shrink-0 size-[20px]" data-node-id="4:891" data-name="Checkbox">
                  <div className="relative shrink-0 size-[13px]" data-node-id="4:892" data-name="check">
                    <img alt="" className="absolute block inset-0 max-w-none size-full" src={imgCheck} />
                  </div>
                </div>
                <p className="[text-decoration-skip-ink:none] [text-underline-position:from-font] [word-break:break-word] decoration-from-font decoration-solid flex-[1_0_0] font-['Inter:Regular'] font-normal leading-[normal] line-through min-w-px not-italic relative text-[#9b9e90] text-[12px]" data-node-id="4:894">
                  Olive oil
                </p>
                <p className="[word-break:break-word] font-['Inter:Regular'] font-normal leading-[normal] not-italic relative shrink-0 text-[#9b9e90] text-[11px] whitespace-nowrap" data-node-id="4:895">
                  3 tbsp
                </p>
              </div>
              <div className="content-stretch flex gap-[11px] h-[32px] items-center overflow-clip relative shrink-0 w-full" data-node-id="4:896" data-name="Grocery">
                <div className="bg-[#386347] border-[#386347] border-[1.3px] border-solid content-stretch flex items-center justify-center overflow-clip relative rounded-[6px] shrink-0 size-[20px]" data-node-id="4:897" data-name="Checkbox">
                  <div className="relative shrink-0 size-[13px]" data-node-id="4:898" data-name="check">
                    <img alt="" className="absolute block inset-0 max-w-none size-full" src={imgCheck} />
                  </div>
                </div>
                <p className="[text-decoration-skip-ink:none] [text-underline-position:from-font] [word-break:break-word] decoration-from-font decoration-solid flex-[1_0_0] font-['Inter:Regular'] font-normal leading-[normal] line-through min-w-px not-italic relative text-[#9b9e90] text-[12px]" data-node-id="4:900">
                  Coconut milk
                </p>
                <p className="[word-break:break-word] font-['Inter:Regular'] font-normal leading-[normal] not-italic relative shrink-0 text-[#9b9e90] text-[11px] whitespace-nowrap" data-node-id="4:901">
                  400 ml
                </p>
              </div>
            </div>
          </div>
          <div className="content-stretch flex flex-col gap-[12px] items-start overflow-clip relative shrink-0 w-full" data-node-id="4:902" data-name="List tools">
            <div className="bg-[#fffef8] border border-[#dfe2d3] border-solid content-stretch flex gap-[9px] h-[43px] items-center overflow-clip px-[14px] relative rounded-[10px] shrink-0 w-full" data-node-id="4:903" data-name="Add grocery">
              <div className="relative shrink-0 size-[17px]" data-node-id="4:904" data-name="plus">
                <img alt="" className="absolute block inset-0 max-w-none size-full" src={imgPlus} />
              </div>
              <p className="[word-break:break-word] flex-[1_0_0] font-['Inter:Regular'] font-normal leading-[1.45] min-w-px not-italic relative text-[#73796b] text-[12px]" data-node-id="4:906">
                Add something else…
              </p>
            </div>
            <div className="content-stretch flex gap-[8px] items-center overflow-clip relative shrink-0 w-full" data-node-id="4:907" data-name="Pantry tip">
              <div className="relative shrink-0 size-[15px]" data-node-id="4:908" data-name="leaf">
                <img alt="" className="absolute block inset-0 max-w-none size-full" src={imgLeaf} />
              </div>
              <p className="[word-break:break-word] flex-[1_0_0] font-['Inter:Regular'] font-normal leading-[1.45] min-w-px not-italic relative text-[#73796b] text-[11px]" data-node-id="4:910">
                Check your cupboards first. A little less waste, a little more saved.
              </p>
            </div>
            <div className="bg-[#fffef8] border border-[#dfe2d3] border-solid content-stretch flex gap-[10px] h-[52px] items-center justify-center overflow-clip relative rounded-[100px] shrink-0 w-full" data-node-id="4:911" data-name="Button">
              <div className="relative shrink-0 size-[18px]" data-node-id="4:912" data-name="users-round">
                <img alt="" className="absolute block inset-0 max-w-none size-full" src={imgUsersRound} />
              </div>
              <p className="[word-break:break-word] font-['Inter:Semi_Bold'] font-semibold leading-[normal] not-italic relative shrink-0 text-[#386347] text-[14px] whitespace-nowrap" data-node-id="4:914">
                Share with your household
              </p>
            </div>
          </div>
        </div>
      </div>
      <div className="bg-[#fffef8] border-[#dfe2d3] border-solid border-t content-stretch flex flex-col gap-[12px] items-center overflow-clip pb-[8px] pt-[10px] px-[15px] relative shrink-0 w-full" data-node-id="4:915" data-name="Bottom navigation">
        <div className="content-stretch flex items-start justify-between overflow-clip relative shrink-0 w-full" data-node-id="4:916" data-name="Destinations">
          <div className="content-stretch flex flex-col gap-[4px] items-center overflow-clip relative shrink-0 w-[60px]" data-node-id="4:917" data-name="Navigation item">
            <div className="bg-[#fffef8] content-stretch flex h-[29px] items-center justify-center overflow-clip relative rounded-[100px] shrink-0 w-[48px]" data-node-id="4:918" data-name="Active indicator">
              <div className="relative shrink-0 size-[21px]" data-node-id="4:919" data-name="house">
                <img alt="" className="absolute block inset-0 max-w-none size-full" src={imgHouse} />
              </div>
            </div>
            <p className="[word-break:break-word] font-['Inter:Regular'] font-normal leading-[normal] not-italic relative shrink-0 text-[#73796b] text-[10px] whitespace-nowrap" data-node-id="4:921">
              Home
            </p>
          </div>
          <div className="content-stretch flex flex-col gap-[4px] items-center overflow-clip relative shrink-0 w-[60px]" data-node-id="4:922" data-name="Navigation item">
            <div className="bg-[#fffef8] content-stretch flex h-[29px] items-center justify-center overflow-clip relative rounded-[100px] shrink-0 w-[48px]" data-node-id="4:923" data-name="Active indicator">
              <div className="relative shrink-0 size-[21px]" data-node-id="4:924" data-name="calendar-days">
                <img alt="" className="absolute block inset-0 max-w-none size-full" src={imgCalendarDays} />
              </div>
            </div>
            <p className="[word-break:break-word] font-['Inter:Regular'] font-normal leading-[normal] not-italic relative shrink-0 text-[#73796b] text-[10px] whitespace-nowrap" data-node-id="4:926">
              Plan
            </p>
          </div>
          <div className="content-stretch flex flex-col gap-[4px] items-center overflow-clip relative shrink-0 w-[60px]" data-node-id="4:927" data-name="Navigation item">
            <div className="bg-[#e7eccd] content-stretch flex h-[29px] items-center justify-center overflow-clip relative rounded-[100px] shrink-0 w-[48px]" data-node-id="4:928" data-name="Active indicator">
              <div className="relative shrink-0 size-[21px]" data-node-id="4:929" data-name="shopping-basket">
                <img alt="" className="absolute block inset-0 max-w-none size-full" src={imgShoppingBasket} />
              </div>
            </div>
            <p className="[word-break:break-word] font-['Inter:Bold'] font-bold leading-[normal] not-italic relative shrink-0 text-[#386347] text-[10px] whitespace-nowrap" data-node-id="4:931">
              Shop
            </p>
          </div>
          <div className="content-stretch flex flex-col gap-[4px] items-center overflow-clip relative shrink-0 w-[60px]" data-node-id="4:932" data-name="Navigation item">
            <div className="bg-[#fffef8] content-stretch flex h-[29px] items-center justify-center overflow-clip relative rounded-[100px] shrink-0 w-[48px]" data-node-id="4:933" data-name="Active indicator">
              <div className="relative shrink-0 size-[21px]" data-node-id="4:934" data-name="book-open">
                <img alt="" className="absolute block inset-0 max-w-none size-full" src={imgBookOpen} />
              </div>
            </div>
            <p className="[word-break:break-word] font-['Inter:Regular'] font-normal leading-[normal] not-italic relative shrink-0 text-[#73796b] text-[10px] whitespace-nowrap" data-node-id="4:936">
              Recipes
            </p>
          </div>
          <div className="content-stretch flex flex-col gap-[4px] items-center overflow-clip relative shrink-0 w-[60px]" data-node-id="4:937" data-name="Navigation item">
            <div className="bg-[#fffef8] content-stretch flex h-[29px] items-center justify-center overflow-clip relative rounded-[100px] shrink-0 w-[48px]" data-node-id="4:938" data-name="Active indicator">
              <div className="relative shrink-0 size-[21px]" data-node-id="4:939" data-name="users-round">
                <img alt="" className="absolute block inset-0 max-w-none size-full" src={imgUsersRound1} />
              </div>
            </div>
            <p className="[word-break:break-word] font-['Inter:Regular'] font-normal leading-[normal] not-italic relative shrink-0 text-[#73796b] text-[10px] whitespace-nowrap" data-node-id="4:941">
              You
            </p>
          </div>
        </div>
        <div className="bg-[#263b2e] h-[4px] relative rounded-[100px] shrink-0 w-[122px]" data-node-id="4:942" data-name="Home indicator" />
      </div>
    </div>
  );
}