const assetPathPrefix = "assets";
const imgRecipePhoto = `${assetPathPrefix}/recipe-photo.png`;
const imgIosSignal = `${assetPathPrefix}/ios-signal.svg`;
const imgIosWifiSignal = `${assetPathPrefix}/ios-wifi-signal.svg`;
const imgIosBatteryFull = `${assetPathPrefix}/ios-battery-full.svg`;
const imgBasilIdleAndTalking = `${assetPathPrefix}/basil-idle-and-talking.svg`;
const imgIconMic = `${assetPathPrefix}/icon-mic.svg`;
const imgIconChat = `${assetPathPrefix}/icon-chat.svg`;

export default function YeschefBurgerMenuOpenProposal() {
  return (
    <div className="bg-[#f8f5ec] content-stretch flex flex-col items-start relative size-full" data-node-id="9:82" data-name="Yeschef burger menu open (proposal)">
      <div className="bg-[#e7eccd] content-stretch flex h-[50px] items-center justify-between overflow-clip px-[28px] relative shrink-0 w-full" data-node-id="9:83" data-name="Status bar">
        <p className="[word-break:break-word] font-['Inter:Semi_Bold'] font-semibold leading-[normal] not-italic relative shrink-0 text-[#263b2e] text-[14px] whitespace-nowrap" data-node-id="9:84">
          9:41
        </p>
        <div className="content-stretch flex gap-[5px] items-center overflow-clip relative shrink-0" data-node-id="9:85" data-name="Device status">
          <div className="relative shrink-0 size-[17px]" data-node-id="9:86" data-name="ios-signal">
            <img alt="" className="absolute block inset-0 max-w-none size-full" src={imgIosSignal} />
          </div>
          <div className="relative shrink-0 size-[17px]" data-node-id="9:88" data-name="ios-wifi-signal">
            <img alt="" className="absolute block inset-0 max-w-none size-full" src={imgIosWifiSignal} />
          </div>
          <div className="h-[17px] relative shrink-0 w-[24px]" data-node-id="9:90" data-name="ios-battery-full">
            <img alt="" className="absolute block inset-0 max-w-none size-full" src={imgIosBatteryFull} />
          </div>
        </div>
      </div>
      <div className="bg-[#e7eccd] h-[256px] overflow-clip relative rounded-bl-[32px] rounded-br-[32px] shrink-0 w-full" data-node-id="9:92" data-name="Chef stage (top third)">
        <div className="absolute bg-[#fffef8] content-stretch flex flex-col gap-px items-center justify-center left-[16px] overflow-clip rounded-[24px] size-[48px] top-[6px]" data-node-id="9:93" data-name="Burger menu button">
          <div className="bg-[#de9f79] h-[8px] relative rounded-tl-[8px] rounded-tr-[8px] shrink-0 w-[26px]" data-node-id="9:94" data-name="Top bun" />
          <div className="bg-[#8fae5f] h-[3px] relative rounded-[1.5px] shrink-0 w-[30px]" data-node-id="9:95" data-name="Lettuce" />
          <div className="bg-[#bc5039] h-[3px] relative rounded-[1.5px] shrink-0 w-[24px]" data-node-id="9:96" data-name="Tomato" />
          <div className="bg-[#f1c95a] h-[3px] relative rounded-[1.5px] shrink-0 w-[27px]" data-node-id="9:97" data-name="Cheese" />
          <div className="bg-[#7a4a2a] h-[5px] relative rounded-[1.5px] shrink-0 w-[26px]" data-node-id="9:98" data-name="Patty" />
          <div className="bg-[#de9f79] h-[5px] relative rounded-bl-[3px] rounded-br-[3px] shrink-0 w-[26px]" data-node-id="9:99" data-name="Bottom bun" />
        </div>
        <div className="absolute bg-[#fffef8] content-stretch flex items-start left-[241px] overflow-clip px-[12px] py-[8px] rounded-[16px] top-[16px]" data-node-id="9:100" data-name="Streak and points">
          <p className="[word-break:break-word] font-['Inter:Semi_Bold'] font-semibold leading-[normal] not-italic relative shrink-0 text-[#386347] text-[11px] whitespace-nowrap" data-node-id="9:101">
            12-day streak, 340 pts
          </p>
        </div>
        <div className="absolute h-[153px] left-[133px] top-[8px] w-[136px]" data-node-id="9:102" data-name="Basil (idle and talking)">
          <img alt="" className="absolute block inset-0 max-w-none size-full" src={imgBasilIdleAndTalking} />
        </div>
        <div className="absolute bg-[#c29465] h-[14px] left-[16px] rounded-[7px] top-[152px] w-[370px]" data-node-id="9:128" data-name="Kitchen counter" />
        <div className="absolute bg-[#fffef8] border-[#386347] border-[1.5px] border-solid content-stretch flex gap-[10px] items-center left-[16px] overflow-clip pl-[16px] pr-[8px] py-[10px] rounded-[22px] top-[173px] w-[370px]" data-node-id="9:129" data-name="Subtitle bar (prompt box)">
          <div className="[word-break:break-word] content-stretch flex flex-col gap-[2px] items-start leading-[normal] not-italic overflow-clip relative shrink-0" data-node-id="9:130" data-name="Subtitle">
            <p className="font-['Inter:Bold'] font-bold relative shrink-0 text-[#386347] text-[10px] tracking-[0.8px] whitespace-nowrap" data-node-id="9:131">
              BASIL
            </p>
            <p className="font-['Inter:Regular'] font-normal relative shrink-0 text-[#263b2e] text-[13px] w-[272px]" data-node-id="9:132">
              Wednesday looks busy, so I lined up 25-minute tacos. Tap to ask me anything.
            </p>
          </div>
          <div className="bg-[#e7eccd] content-stretch flex items-center justify-center overflow-clip relative rounded-[20px] shrink-0 size-[40px]" data-node-id="9:133" data-name="Mic button">
            <div className="relative shrink-0 size-[20px]" data-node-id="9:134" data-name="icon/mic">
              <img alt="" className="absolute block inset-0 max-w-none size-full" src={imgIconMic} />
            </div>
          </div>
        </div>
      </div>
      <div className="content-stretch flex flex-col gap-[12px] items-start overflow-clip px-[20px] py-[18px] relative shrink-0 w-full" data-node-id="9:137" data-name="Output (bottom two thirds)">
        <p className="[word-break:break-word] font-['Fraunces:SemiBold'] font-semibold leading-[normal] relative shrink-0 text-[#263b2e] text-[24px] whitespace-nowrap" data-node-id="9:138" style={{ fontVariationSettings: '"SOFT" 0, "WONK" 1' }}>
          Tonight
        </p>
        <div className="bg-[#fffef8] content-stretch flex flex-col items-start overflow-clip relative rounded-[20px] shrink-0 w-full" data-node-id="9:139" data-name="Recipe card">
          <div className="h-[132px] relative shrink-0 w-full" data-node-id="9:140" data-name="Recipe photo">
            <img alt="" className="absolute inset-0 max-w-none object-cover pointer-events-none size-full" src={imgRecipePhoto} />
          </div>
          <div className="content-stretch flex flex-col gap-[4px] items-start overflow-clip pb-[14px] pt-[12px] px-[16px] relative shrink-0 w-full" data-node-id="9:141" data-name="Recipe info">
            <p className="[word-break:break-word] font-['Inter:Bold'] font-bold leading-[normal] not-italic relative shrink-0 text-[#386347] text-[10px] tracking-[0.8px] whitespace-nowrap" data-node-id="9:142">
              MONDAY DINNER
            </p>
            <p className="[word-break:break-word] font-['Fraunces:SemiBold'] font-semibold leading-[normal] relative shrink-0 text-[#263b2e] text-[21px] whitespace-nowrap" data-node-id="9:143" style={{ fontVariationSettings: '"SOFT" 0, "WONK" 1' }}>{`Lemon & herb salmon`}</p>
            <p className="[word-break:break-word] font-['Inter:Regular'] font-normal leading-[normal] not-italic relative shrink-0 text-[#73796b] text-[12px] whitespace-nowrap" data-node-id="9:144">
              30 min, serves 4, one tray
            </p>
            <div className="bg-[#386347] content-stretch flex items-start overflow-clip px-[16px] py-[9px] relative rounded-[18px] shrink-0" data-node-id="9:145" data-name="Start cooking button">
              <p className="[word-break:break-word] font-['Inter:Semi_Bold'] font-semibold leading-[normal] not-italic relative shrink-0 text-[#fffef8] text-[13px] whitespace-nowrap" data-node-id="9:146">
                Start cooking with Basil
              </p>
            </div>
          </div>
        </div>
        <p className="[word-break:break-word] font-['Fraunces:SemiBold'] font-semibold leading-[normal] relative shrink-0 text-[#263b2e] text-[20px] whitespace-nowrap" data-node-id="9:147" style={{ fontVariationSettings: '"SOFT" 0, "WONK" 1' }}>
          This week
        </p>
        <div className="[word-break:break-word] content-stretch flex gap-[10px] items-start leading-[normal] overflow-clip relative shrink-0 w-full whitespace-nowrap" data-node-id="9:148" data-name="Week stats">
          <div className="bg-[#fffef8] content-stretch flex flex-[1_0_0] flex-col gap-[2px] items-start min-w-px overflow-clip px-[12px] py-[10px] relative rounded-[16px]" data-node-id="9:149" data-name="Stat">
            <p className="font-['Fraunces:SemiBold'] font-semibold relative shrink-0 text-[#263b2e] text-[25px]" data-node-id="9:150" style={{ fontVariationSettings: '"SOFT" 0, "WONK" 1' }}>
              7
            </p>
            <p className="font-['Inter:Regular'] font-normal not-italic relative shrink-0 text-[#73796b] text-[11px]" data-node-id="9:151">
              dinners planned
            </p>
          </div>
          <div className="bg-[#fffef8] content-stretch flex flex-[1_0_0] flex-col gap-[2px] items-start min-w-px overflow-clip px-[12px] py-[10px] relative rounded-[16px]" data-node-id="9:152" data-name="Stat">
            <p className="font-['Fraunces:SemiBold'] font-semibold relative shrink-0 text-[#263b2e] text-[25px]" data-node-id="9:153" style={{ fontVariationSettings: '"SOFT" 0, "WONK" 1' }}>
              18
            </p>
            <p className="font-['Inter:Regular'] font-normal not-italic relative shrink-0 text-[#73796b] text-[11px]" data-node-id="9:154">
              groceries to get
            </p>
          </div>
          <div className="bg-[#fffef8] content-stretch flex flex-[1_0_0] flex-col gap-[2px] items-start min-w-px overflow-clip px-[12px] py-[10px] relative rounded-[16px]" data-node-id="9:155" data-name="Stat">
            <p className="font-['Fraunces:SemiBold'] font-semibold relative shrink-0 text-[#263b2e] text-[25px]" data-node-id="9:156" style={{ fontVariationSettings: '"SOFT" 0, "WONK" 1' }}>
              3
            </p>
            <p className="font-['Inter:Regular'] font-normal not-italic relative shrink-0 text-[#73796b] text-[11px]" data-node-id="9:157">
              veggie nights
            </p>
          </div>
        </div>
      </div>
      <div className="absolute bg-[#386347] content-stretch flex items-center justify-center left-[322px] overflow-clip rounded-[30px] shadow-[0px_4px_12px_0px_rgba(38,59,46,0.25)] size-[60px] top-[780px]" data-node-id="9:158" data-name="Chat bubble button">
        <div className="relative shrink-0 size-[26px]" data-node-id="9:159" data-name="icon/chat">
          <img alt="" className="absolute block inset-0 max-w-none size-full" src={imgIconChat} />
        </div>
      </div>
      <div className="absolute bg-[#263b2e] h-[5px] left-[134px] rounded-[3px] top-[861px] w-[134px]" data-node-id="9:161" data-name="Home indicator" />
      <div className="absolute bg-[rgba(38,59,46,0.55)] h-[874px] left-0 top-0 w-[402px]" data-node-id="9:162" data-name="Dim overlay" />
      <div className="[word-break:break-word] absolute content-stretch flex flex-col gap-[6px] items-start leading-[normal] left-[16px] not-italic overflow-clip top-[60px] whitespace-nowrap" data-node-id="9:163" data-name="Burger menu (open)">
        <div className="bg-[#de9f79] content-stretch flex gap-[8px] items-center overflow-clip pb-[14px] pt-[22px] px-[20px] relative rounded-bl-[10px] rounded-br-[10px] rounded-tl-[40px] rounded-tr-[40px] shrink-0 w-[270px]" data-node-id="9:164" data-name="Top bun: This week's plan">
          <p className="font-['Inter:Semi_Bold'] font-semibold relative shrink-0 text-[#263b2e] text-[15px]" data-node-id="9:165">{`This week's plan`}</p>
          <p className="font-['Inter:Regular'] font-normal relative shrink-0 text-[11px] text-[rgba(38,59,46,0.7)]" data-node-id="9:166">
            top bun
          </p>
        </div>
        <div className="bg-[#8fae5f] content-stretch flex gap-[8px] items-center overflow-clip px-[20px] py-[14px] relative rounded-[12px] shrink-0 w-[282px]" data-node-id="9:167" data-name="Lettuce: Recipes">
          <p className="font-['Inter:Semi_Bold'] font-semibold relative shrink-0 text-[#263b2e] text-[15px]" data-node-id="9:168">
            Recipes
          </p>
          <p className="font-['Inter:Regular'] font-normal relative shrink-0 text-[11px] text-[rgba(38,59,46,0.7)]" data-node-id="9:169">
            lettuce
          </p>
        </div>
        <div className="bg-[#bc5039] content-stretch flex gap-[8px] items-center overflow-clip px-[20px] py-[14px] relative rounded-[12px] shrink-0 w-[276px]" data-node-id="9:170" data-name="Tomato: Shopping list">
          <p className="font-['Inter:Semi_Bold'] font-semibold relative shrink-0 text-[#fffef8] text-[15px]" data-node-id="9:171">
            Shopping list
          </p>
          <p className="font-['Inter:Regular'] font-normal relative shrink-0 text-[11px] text-[rgba(255,254,248,0.7)]" data-node-id="9:172">
            tomato
          </p>
        </div>
        <div className="bg-[#f1c95a] content-stretch flex gap-[8px] items-center overflow-clip px-[20px] py-[14px] relative rounded-[12px] shrink-0 w-[280px]" data-node-id="9:173" data-name="Cheese: Family and preferences">
          <p className="font-['Inter:Semi_Bold'] font-semibold relative shrink-0 text-[#263b2e] text-[15px]" data-node-id="9:174">
            Family and preferences
          </p>
          <p className="font-['Inter:Regular'] font-normal relative shrink-0 text-[11px] text-[rgba(38,59,46,0.7)]" data-node-id="9:175">
            cheese
          </p>
        </div>
        <div className="bg-[#7a4a2a] content-stretch flex gap-[8px] items-center overflow-clip px-[20px] py-[14px] relative rounded-[12px] shrink-0 w-[274px]" data-node-id="9:176" data-name="Patty: Basil's wardrobe">
          <p className="font-['Inter:Semi_Bold'] font-semibold relative shrink-0 text-[#fffef8] text-[15px]" data-node-id="9:177">{`Basil's wardrobe`}</p>
          <p className="font-['Inter:Regular'] font-normal relative shrink-0 text-[11px] text-[rgba(255,254,248,0.7)]" data-node-id="9:178">
            patty
          </p>
        </div>
        <div className="bg-[#de9f79] content-stretch flex gap-[8px] items-center overflow-clip px-[20px] py-[14px] relative rounded-bl-[24px] rounded-br-[24px] rounded-tl-[10px] rounded-tr-[10px] shrink-0 w-[270px]" data-node-id="9:179" data-name="Bottom bun: Settings">
          <p className="font-['Inter:Semi_Bold'] font-semibold relative shrink-0 text-[#263b2e] text-[15px]" data-node-id="9:180">
            Settings
          </p>
          <p className="font-['Inter:Regular'] font-normal relative shrink-0 text-[11px] text-[rgba(38,59,46,0.7)]" data-node-id="9:181">
            bottom bun
          </p>
        </div>
      </div>
      <p className="[word-break:break-word] absolute font-['Inter:Regular'] font-normal leading-[normal] left-[16px] not-italic text-[#fffef8] text-[12px] top-[388px] whitespace-nowrap" data-node-id="9:182">
        Tap a layer to open it. Tap outside the burger to close it.
      </p>
    </div>
  );
}