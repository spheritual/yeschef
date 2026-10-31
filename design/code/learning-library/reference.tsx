const assetPathPrefix = "assets";
const imgTechniquePhotography = `${assetPathPrefix}/technique-photography.png`;
const imgTechniquePhotography1 = `${assetPathPrefix}/technique-photography1.png`;
const imgTechniquePhotography2 = `${assetPathPrefix}/technique-photography2.png`;
const imgTechniquePhotography3 = `${assetPathPrefix}/technique-photography3.png`;
const imgTechniquePhotography4 = `${assetPathPrefix}/technique-photography4.png`;
const imgDeviceStatus = `${assetPathPrefix}/device-status.svg`;
const imgBasilTheChef = `${assetPathPrefix}/basil-the-chef.svg`;
const imgArrowLeft = `${assetPathPrefix}/arrow-left.svg`;
const imgSearch = `${assetPathPrefix}/search.svg`;
const imgPlay = `${assetPathPrefix}/play.svg`;
const imgPlay1 = `${assetPathPrefix}/play1.svg`;
const imgPlay2 = `${assetPathPrefix}/play2.svg`;
const imgSprout = `${assetPathPrefix}/sprout.svg`;

export default function LearningLibrary() {
  return (
    <div className="bg-[#f8f5ec] content-stretch flex flex-col items-start overflow-clip relative rounded-[32px] size-full" data-node-id="19:838" data-name="Learning library">
      <div className="bg-[#e7eccd] content-stretch flex flex-col items-start overflow-clip relative rounded-bl-[32px] rounded-br-[32px] shrink-0 w-full" data-node-id="19:839" data-name="Basil's kitchen">
        <div className="content-stretch flex h-[50px] items-center justify-between overflow-clip px-[28px] relative shrink-0 w-full" data-node-id="19:840" data-name="Status bar">
          <p className="[word-break:break-word] font-['Inter:Semi_Bold'] font-semibold leading-[normal] not-italic relative shrink-0 text-[#263b2e] text-[14px] whitespace-nowrap" data-node-id="19:841">
            9:41
          </p>
          <div className="h-[17px] relative shrink-0 w-[68px]" data-node-id="19:842" data-name="Device status">
            <img alt="" className="absolute block inset-0 max-w-none size-full" src={imgDeviceStatus} />
          </div>
        </div>
        <div className="h-[170px] overflow-clip relative shrink-0 w-full" data-node-id="19:846" data-name="Chef stage">
          <div className="absolute bg-[#c29465] h-[10px] left-[24px] rounded-[6px] top-[148px] w-[354px]" data-node-id="19:882" data-name="Kitchen counter" />
          <div className="absolute bg-[#fffef8] content-stretch flex items-start left-[285px] overflow-clip px-[12px] py-[8px] rounded-[100px] top-[14px]" data-node-id="19:880" data-name="Area label">
            <p className="[word-break:break-word] font-['Inter:Semi_Bold'] font-semibold leading-[normal] not-italic relative shrink-0 text-[#386347] text-[11px] whitespace-nowrap" data-node-id="19:881">
              Learning
            </p>
          </div>
          <div className="absolute bg-[#fffef8] content-stretch flex flex-col gap-px items-center justify-center left-[20px] overflow-clip rounded-[100px] size-[42px] top-[6px]" data-node-id="19:873" data-name="Menu button">
            <div className="bg-[#de9f79] h-[7px] relative rounded-tl-[7px] rounded-tr-[7px] shrink-0 w-[23px]" data-node-id="19:874" data-name="Top bun" />
            <div className="bg-[#8fae5f] h-[3px] relative rounded-[2px] shrink-0 w-[26px]" data-node-id="19:875" data-name="Lettuce" />
            <div className="bg-[#bc5039] h-[3px] relative rounded-[2px] shrink-0 w-[22px]" data-node-id="19:876" data-name="Tomato" />
            <div className="bg-[#f1c95a] h-[3px] relative rounded-[2px] shrink-0 w-[24px]" data-node-id="19:877" data-name="Cheese" />
            <div className="bg-[#7a4a2a] h-[4px] relative rounded-[2px] shrink-0 w-[23px]" data-node-id="19:878" data-name="Patty" />
            <div className="bg-[#de9f79] h-[4px] relative rounded-[2px] shrink-0 w-[23px]" data-node-id="19:879" data-name="Bottom bun" />
          </div>
          <div className="absolute h-[153px] left-[133px] top-0 w-[136px]" data-node-id="19:847" data-name="Basil the chef">
            <img alt="" className="absolute block inset-0 max-w-none size-full" src={imgBasilTheChef} />
          </div>
        </div>
      </div>
      <div className="content-stretch flex flex-col gap-[24px] items-start overflow-clip pb-[16px] pt-[20px] px-[24px] relative shrink-0 w-full" data-node-id="19:883" data-name="Learning content">
        <div className="content-stretch flex flex-col gap-[8px] items-start overflow-clip relative shrink-0 w-full" data-node-id="19:884" data-name="Introduction">
          <div className="content-stretch flex gap-[6px] items-center overflow-clip relative shrink-0 w-full" data-node-id="19:885" data-name="Recipes connection">
            <div className="relative shrink-0 size-[14px]" data-node-id="19:1127" data-name="arrow-left">
              <img alt="" className="absolute block inset-0 max-w-none size-full" src={imgArrowLeft} />
            </div>
            <p className="[word-break:break-word] font-['Inter:Semi_Bold'] font-semibold leading-[normal] not-italic relative shrink-0 text-[#386347] text-[11px] whitespace-nowrap" data-node-id="19:887">
              Recipes
            </p>
            <p className="[word-break:break-word] font-['Inter:Regular'] font-normal leading-[normal] not-italic relative shrink-0 text-[#73796b] text-[11px] whitespace-nowrap" data-node-id="19:888">
              / Learning
            </p>
          </div>
          <div className="[word-break:break-word] font-['Fraunces:SemiBold'] font-semibold leading-[0] relative shrink-0 text-[#263b2e] text-[32px] tracking-[-0.7px] w-full" data-node-id="19:889" style={{ fontVariationSettings: '"SOFT" 0, "WONK" 1' }}>
            <p className="leading-[normal] mb-0">A little learning.</p>
            <p className="leading-[normal]">A lot more confidence.</p>
          </div>
          <p className="[word-break:break-word] font-['Inter:Regular'] font-normal leading-[1.45] not-italic relative shrink-0 text-[#73796b] text-[13px] w-full" data-node-id="19:890">
            Short videos for the little things that make a big difference. Let’s learn with Basil.
          </p>
        </div>
        <div className="content-stretch flex flex-col gap-[12px] items-start overflow-clip relative shrink-0 w-full" data-node-id="19:891" data-name="Browse techniques">
          <div className="bg-[#fffef8] border border-[#dfe2d3] border-solid content-stretch flex gap-[10px] h-[47px] items-center overflow-clip px-[14px] relative rounded-[10px] shrink-0 w-full" data-node-id="19:892" data-name="Search techniques">
            <div className="relative shrink-0 size-[18px]" data-node-id="19:1130" data-name="search">
              <img alt="" className="absolute block inset-0 max-w-none size-full" src={imgSearch} />
            </div>
            <p className="[word-break:break-word] font-['Inter:Regular'] font-normal leading-[normal] not-italic relative shrink-0 text-[#73796b] text-[12px] whitespace-nowrap" data-node-id="19:894">
              What would you like to learn?
            </p>
          </div>
          <div className="content-stretch flex gap-[7px] items-start overflow-clip relative shrink-0 w-full" data-node-id="19:895" data-name="Technique categories">
            <div className="bg-[#386347] content-stretch flex items-start overflow-clip px-[13px] py-[9px] relative rounded-[100px] shrink-0" data-node-id="19:896" data-name="Category">
              <p className="[word-break:break-word] font-['Inter:Semi_Bold'] font-semibold leading-[normal] not-italic relative shrink-0 text-[#fffef8] text-[11px] whitespace-nowrap" data-node-id="19:897">
                All videos
              </p>
            </div>
            <div className="bg-[#f0f1e7] content-stretch flex items-start overflow-clip px-[13px] py-[9px] relative rounded-[100px] shrink-0" data-node-id="19:898" data-name="Category">
              <p className="[word-break:break-word] font-['Inter:Semi_Bold'] font-semibold leading-[normal] not-italic relative shrink-0 text-[#386347] text-[11px] whitespace-nowrap" data-node-id="19:899">
                Knife skills
              </p>
            </div>
            <div className="bg-[#f0f1e7] content-stretch flex items-start overflow-clip px-[13px] py-[9px] relative rounded-[100px] shrink-0" data-node-id="19:900" data-name="Category">
              <p className="[word-break:break-word] font-['Inter:Semi_Bold'] font-semibold leading-[normal] not-italic relative shrink-0 text-[#386347] text-[11px] whitespace-nowrap" data-node-id="19:901">{`Heat & pans`}</p>
            </div>
            <div className="bg-[#f0f1e7] content-stretch flex items-start overflow-clip px-[13px] py-[9px] relative rounded-[100px] shrink-0" data-node-id="19:902" data-name="Category">
              <p className="[word-break:break-word] font-['Inter:Semi_Bold'] font-semibold leading-[normal] not-italic relative shrink-0 text-[#386347] text-[11px] whitespace-nowrap" data-node-id="19:903">
                Prep
              </p>
            </div>
          </div>
        </div>
        <div className="content-stretch flex flex-col gap-[12px] items-start overflow-clip relative shrink-0 w-full" data-node-id="19:904" data-name="Featured lesson">
          <div className="content-stretch flex items-center justify-between overflow-clip relative shrink-0 w-full" data-node-id="19:905" data-name="Section heading">
            <p className="[word-break:break-word] font-['Fraunces:SemiBold'] font-semibold leading-[normal] relative shrink-0 text-[#263b2e] text-[22px] whitespace-nowrap" data-node-id="19:906" style={{ fontVariationSettings: '"SOFT" 0, "WONK" 1' }}>
              A skill for tonight
            </p>
          </div>
          <div className="bg-[#fffef8] border border-[#dfe2d3] border-solid content-stretch flex flex-col items-start overflow-clip relative rounded-[20px] shrink-0 w-full" data-node-id="19:907" data-name="Featured video">
            <div className="content-stretch flex flex-col h-[192px] items-start overflow-clip relative shrink-0 w-full" data-node-id="19:908" data-name="Video thumbnail">
              <div className="absolute h-[192px] left-0 top-0 w-[354px]" data-node-id="19:909" data-name="Technique photography">
                <img alt="" className="absolute inset-0 max-w-none object-cover pointer-events-none size-full" src={imgTechniquePhotography} />
              </div>
              <div className="absolute bg-[#fffef8] content-stretch flex items-center justify-center left-[151px] overflow-clip rounded-[100px] size-[52px] top-[70px]" data-node-id="19:910" data-name="Play video">
                <div className="relative shrink-0 size-[23px]" data-node-id="19:1133" data-name="play">
                  <img alt="" className="absolute block inset-0 max-w-none size-full" src={imgPlay} />
                </div>
              </div>
              <div className="absolute bg-[rgba(20,37,28,0.8)] content-stretch flex h-[20px] items-center justify-center left-[301px] overflow-clip rounded-[6px] top-[164px] w-[45px]" data-node-id="19:912" data-name="Duration badge">
                <p className="[word-break:break-word] font-['Inter:Semi_Bold'] font-semibold leading-[normal] not-italic relative shrink-0 text-[10px] text-white whitespace-nowrap" data-node-id="19:913">
                  4:32
                </p>
              </div>
            </div>
            <div className="content-stretch flex flex-col gap-[8px] items-start overflow-clip p-[16px] relative shrink-0 w-full" data-node-id="19:914" data-name="Featured information">
              <p className="[word-break:break-word] font-['Inter:Bold'] font-bold leading-[normal] not-italic relative shrink-0 text-[#386347] text-[9px] tracking-[0.7px] whitespace-nowrap" data-node-id="19:915">{`HEAT & PANS · BEGINNER`}</p>
              <p className="[word-break:break-word] font-['Fraunces:SemiBold'] font-semibold leading-[normal] min-w-full relative shrink-0 text-[#263b2e] text-[23px] w-[min-content]" data-node-id="19:916" style={{ fontVariationSettings: '"SOFT" 0, "WONK" 1' }}>
                Pan-sear salmon, beautifully
              </p>
              <div className="[word-break:break-word] font-['Inter:Regular'] font-normal leading-[0] min-w-full not-italic relative shrink-0 text-[#73796b] text-[12px] w-[min-content]" data-node-id="19:917">
                <p className="leading-[1.45] mb-0">Crisp skin, a tender middle, and no sticking.</p>
                <p className="leading-[1.45]">{`A new way with your lemon & herb salmon.`}</p>
              </div>
              <div className="bg-[#386347] content-stretch flex gap-[8px] h-[42px] items-center justify-center overflow-clip relative rounded-[100px] shrink-0 w-full" data-node-id="19:918" data-name="Watch lesson button">
                <div className="relative shrink-0 size-[15px]" data-node-id="19:1136" data-name="play">
                  <img alt="" className="absolute block inset-0 max-w-none size-full" src={imgPlay1} />
                </div>
                <p className="[word-break:break-word] font-['Inter:Semi_Bold'] font-semibold leading-[normal] not-italic relative shrink-0 text-[#fffef8] text-[12px] whitespace-nowrap" data-node-id="19:920">
                  Learn this technique
                </p>
              </div>
            </div>
          </div>
        </div>
        <div className="content-stretch flex flex-col gap-[12px] items-start overflow-clip relative shrink-0 w-full" data-node-id="19:921" data-name="Technique collection">
          <div className="[word-break:break-word] content-stretch flex items-center justify-between leading-[normal] overflow-clip relative shrink-0 w-full whitespace-nowrap" data-node-id="19:922" data-name="Section heading">
            <p className="font-['Fraunces:SemiBold'] font-semibold relative shrink-0 text-[#263b2e] text-[22px]" data-node-id="19:923" style={{ fontVariationSettings: '"SOFT" 0, "WONK" 1' }}>
              Small skills, big wins
            </p>
            <p className="font-['Inter:Regular'] font-normal not-italic relative shrink-0 text-[#73796b] text-[11px]" data-node-id="19:924">
              4 quick lessons
            </p>
          </div>
          <div className="content-stretch flex gap-[12px] items-start overflow-clip relative shrink-0 w-full" data-node-id="19:925" data-name="Video row">
            <div className="bg-[#fffef8] border border-[#dfe2d3] border-solid content-stretch flex flex-[1_0_0] flex-col items-start min-w-px overflow-clip relative rounded-[16px] self-stretch" data-node-id="19:926" data-name="Technique video">
              <div className="content-stretch flex flex-col h-[108px] items-start overflow-clip relative shrink-0 w-full" data-node-id="19:927" data-name="Video thumbnail">
                <div className="absolute h-[108px] left-0 top-0 w-[171px]" data-node-id="19:928" data-name="Technique photography">
                  <img alt="" className="absolute inset-0 max-w-none object-cover pointer-events-none size-full" src={imgTechniquePhotography1} />
                </div>
                <div className="absolute bg-[#fffef8] content-stretch flex items-center justify-center left-[69.5px] overflow-clip rounded-[100px] size-[32px] top-[38px]" data-node-id="19:929" data-name="Play video">
                  <div className="relative shrink-0 size-[15px]" data-node-id="19:1139" data-name="play">
                    <img alt="" className="absolute block inset-0 max-w-none size-full" src={imgPlay2} />
                  </div>
                </div>
                <div className="absolute bg-[rgba(20,37,28,0.8)] content-stretch flex h-[20px] items-center justify-center left-[118px] overflow-clip rounded-[6px] top-[80px] w-[45px]" data-node-id="19:931" data-name="Duration badge">
                  <p className="[word-break:break-word] font-['Inter:Semi_Bold'] font-semibold leading-[normal] not-italic relative shrink-0 text-[10px] text-white whitespace-nowrap" data-node-id="19:932">
                    3:15
                  </p>
                </div>
              </div>
              <div className="[word-break:break-word] content-stretch flex flex-col gap-[6px] items-start overflow-clip p-[11px] relative shrink-0 w-full" data-node-id="19:933" data-name="Video information">
                <p className="font-['Inter:Bold'] font-bold leading-[normal] not-italic relative shrink-0 text-[#386347] text-[9px] tracking-[0.5px] whitespace-nowrap" data-node-id="19:934">
                  KNIFE SKILLS
                </p>
                <p className="font-['Fraunces:SemiBold'] font-semibold leading-[1.15] min-w-full relative shrink-0 text-[#263b2e] text-[18px] w-[min-content]" data-node-id="19:935" style={{ fontVariationSettings: '"SOFT" 0, "WONK" 1' }}>
                  Dice an onion, safely
                </p>
                <p className="font-['Inter:Regular'] font-normal leading-[normal] not-italic relative shrink-0 text-[#73796b] text-[10px] whitespace-nowrap" data-node-id="19:936">
                  Beginner friendly
                </p>
              </div>
            </div>
            <div className="bg-[#fffef8] border border-[#dfe2d3] border-solid content-stretch flex flex-[1_0_0] flex-col items-start min-w-px overflow-clip relative rounded-[16px] self-stretch" data-node-id="19:937" data-name="Technique video">
              <div className="content-stretch flex flex-col h-[108px] items-start overflow-clip relative shrink-0 w-full" data-node-id="19:938" data-name="Video thumbnail">
                <div className="absolute h-[108px] left-0 top-0 w-[171px]" data-node-id="19:939" data-name="Technique photography">
                  <img alt="" className="absolute inset-0 max-w-none object-cover pointer-events-none size-full" src={imgTechniquePhotography2} />
                </div>
                <div className="absolute bg-[#fffef8] content-stretch flex items-center justify-center left-[69.5px] overflow-clip rounded-[100px] size-[32px] top-[38px]" data-node-id="19:940" data-name="Play video">
                  <div className="relative shrink-0 size-[15px]" data-node-id="19:1142" data-name="play">
                    <img alt="" className="absolute block inset-0 max-w-none size-full" src={imgPlay2} />
                  </div>
                </div>
                <div className="absolute bg-[rgba(20,37,28,0.8)] content-stretch flex h-[20px] items-center justify-center left-[118px] overflow-clip rounded-[6px] top-[80px] w-[45px]" data-node-id="19:942" data-name="Duration badge">
                  <p className="[word-break:break-word] font-['Inter:Semi_Bold'] font-semibold leading-[normal] not-italic relative shrink-0 text-[10px] text-white whitespace-nowrap" data-node-id="19:943">
                    4:10
                  </p>
                </div>
              </div>
              <div className="[word-break:break-word] content-stretch flex flex-col gap-[6px] items-start overflow-clip p-[11px] relative shrink-0 w-full" data-node-id="19:944" data-name="Video information">
                <p className="font-['Inter:Bold'] font-bold leading-[normal] not-italic relative shrink-0 text-[#386347] text-[9px] tracking-[0.5px] whitespace-nowrap" data-node-id="19:945">{`HEAT & PANS`}</p>
                <p className="font-['Fraunces:SemiBold'] font-semibold leading-[1.15] min-w-full relative shrink-0 text-[#263b2e] text-[18px] w-[min-content]" data-node-id="19:946" style={{ fontVariationSettings: '"SOFT" 0, "WONK" 1' }}>
                  Roast veg just right
                </p>
                <p className="font-['Inter:Regular'] font-normal leading-[normal] not-italic relative shrink-0 text-[#73796b] text-[10px] whitespace-nowrap" data-node-id="19:947">
                  Beginner friendly
                </p>
              </div>
            </div>
          </div>
          <div className="content-stretch flex gap-[12px] items-start overflow-clip relative shrink-0 w-full" data-node-id="19:948" data-name="Video row">
            <div className="bg-[#fffef8] border border-[#dfe2d3] border-solid content-stretch flex flex-[1_0_0] flex-col items-start min-w-px overflow-clip relative rounded-[16px] self-stretch" data-node-id="19:949" data-name="Technique video">
              <div className="content-stretch flex flex-col h-[108px] items-start overflow-clip relative shrink-0 w-full" data-node-id="19:950" data-name="Video thumbnail">
                <div className="absolute h-[108px] left-0 top-0 w-[171px]" data-node-id="19:951" data-name="Technique photography">
                  <img alt="" className="absolute inset-0 max-w-none object-cover pointer-events-none size-full" src={imgTechniquePhotography3} />
                </div>
                <div className="absolute bg-[#fffef8] content-stretch flex items-center justify-center left-[69.5px] overflow-clip rounded-[100px] size-[32px] top-[38px]" data-node-id="19:952" data-name="Play video">
                  <div className="relative shrink-0 size-[15px]" data-node-id="19:1145" data-name="play">
                    <img alt="" className="absolute block inset-0 max-w-none size-full" src={imgPlay2} />
                  </div>
                </div>
                <div className="absolute bg-[rgba(20,37,28,0.8)] content-stretch flex h-[20px] items-center justify-center left-[118px] overflow-clip rounded-[6px] top-[80px] w-[45px]" data-node-id="19:954" data-name="Duration badge">
                  <p className="[word-break:break-word] font-['Inter:Semi_Bold'] font-semibold leading-[normal] not-italic relative shrink-0 text-[10px] text-white whitespace-nowrap" data-node-id="19:955">
                    2:40
                  </p>
                </div>
              </div>
              <div className="[word-break:break-word] content-stretch flex flex-col gap-[6px] items-start overflow-clip p-[11px] relative shrink-0 w-full" data-node-id="19:956" data-name="Video information">
                <p className="font-['Inter:Bold'] font-bold leading-[normal] not-italic relative shrink-0 text-[#386347] text-[9px] tracking-[0.5px] whitespace-nowrap" data-node-id="19:957">{`SAUCES & PREP`}</p>
                <p className="font-['Fraunces:SemiBold'] font-semibold leading-[1.15] min-w-full relative shrink-0 text-[#263b2e] text-[18px] w-[min-content]" data-node-id="19:958" style={{ fontVariationSettings: '"SOFT" 0, "WONK" 1' }}>
                  A dressing that stays together
                </p>
                <p className="font-['Inter:Regular'] font-normal leading-[normal] not-italic relative shrink-0 text-[#73796b] text-[10px] whitespace-nowrap" data-node-id="19:959">
                  Beginner friendly
                </p>
              </div>
            </div>
            <div className="bg-[#fffef8] border border-[#dfe2d3] border-solid content-stretch flex flex-[1_0_0] flex-col items-start min-w-px overflow-clip relative rounded-[16px] self-stretch" data-node-id="19:960" data-name="Technique video">
              <div className="content-stretch flex flex-col h-[108px] items-start overflow-clip relative shrink-0 w-full" data-node-id="19:961" data-name="Video thumbnail">
                <div className="absolute h-[108px] left-0 top-0 w-[171px]" data-node-id="19:962" data-name="Technique photography">
                  <img alt="" className="absolute inset-0 max-w-none object-cover pointer-events-none size-full" src={imgTechniquePhotography4} />
                </div>
                <div className="absolute bg-[#fffef8] content-stretch flex items-center justify-center left-[69.5px] overflow-clip rounded-[100px] size-[32px] top-[38px]" data-node-id="19:963" data-name="Play video">
                  <div className="relative shrink-0 size-[15px]" data-node-id="19:1148" data-name="play">
                    <img alt="" className="absolute block inset-0 max-w-none size-full" src={imgPlay2} />
                  </div>
                </div>
                <div className="absolute bg-[rgba(20,37,28,0.8)] content-stretch flex h-[20px] items-center justify-center left-[118px] overflow-clip rounded-[6px] top-[80px] w-[45px]" data-node-id="19:965" data-name="Duration badge">
                  <p className="[word-break:break-word] font-['Inter:Semi_Bold'] font-semibold leading-[normal] not-italic relative shrink-0 text-[10px] text-white whitespace-nowrap" data-node-id="19:966">
                    1:50
                  </p>
                </div>
              </div>
              <div className="[word-break:break-word] content-stretch flex flex-col gap-[6px] items-start overflow-clip p-[11px] relative shrink-0 w-full" data-node-id="19:967" data-name="Video information">
                <p className="font-['Inter:Bold'] font-bold leading-[normal] not-italic relative shrink-0 text-[#386347] text-[9px] tracking-[0.5px] whitespace-nowrap" data-node-id="19:968">
                  KNIFE SKILLS
                </p>
                <p className="font-['Fraunces:SemiBold'] font-semibold leading-[1.15] min-w-full relative shrink-0 text-[#263b2e] text-[18px] w-[min-content]" data-node-id="19:969" style={{ fontVariationSettings: '"SOFT" 0, "WONK" 1' }}>
                  Mince garlic with ease
                </p>
                <p className="font-['Inter:Regular'] font-normal leading-[normal] not-italic relative shrink-0 text-[#73796b] text-[10px] whitespace-nowrap" data-node-id="19:970">
                  Beginner friendly
                </p>
              </div>
            </div>
          </div>
        </div>
        <div className="bg-[#e7eccd] content-stretch flex gap-[10px] items-center overflow-clip p-[14px] relative rounded-[16px] shrink-0 w-full" data-node-id="19:971" data-name="Basil encouragement">
          <div className="relative shrink-0 size-[23px]" data-node-id="19:1151" data-name="sprout">
            <img alt="" className="absolute block inset-0 max-w-none size-full" src={imgSprout} />
          </div>
          <p className="[word-break:break-word] flex-[1_0_0] font-['Inter:Regular'] font-normal leading-[1.45] min-w-px not-italic relative text-[#386347] text-[12px]" data-node-id="19:973">
            One little skill at a time. You don’t have to be a chef to cook with confidence.
          </p>
        </div>
      </div>
      <div className="content-stretch flex h-[32px] items-center justify-center overflow-clip relative shrink-0 w-full" data-node-id="19:974" data-name="Gesture area">
        <div className="bg-[#263b2e] h-[5px] relative rounded-[3px] shrink-0 w-[134px]" data-node-id="19:975" data-name="Home indicator" />
      </div>
    </div>
  );
}