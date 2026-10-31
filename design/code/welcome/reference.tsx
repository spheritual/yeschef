const assetPathPrefix = "assets";
const imgIosSignal = `${assetPathPrefix}/ios-signal.svg`;
const imgIosWifiSignal = `${assetPathPrefix}/ios-wifi-signal.svg`;
const imgIosBatteryFull = `${assetPathPrefix}/ios-battery-full.svg`;
const imgBasilTheChef = `${assetPathPrefix}/basil-the-chef.svg`;
const imgLeaf = `${assetPathPrefix}/leaf.svg`;
const imgSprout = `${assetPathPrefix}/sprout.svg`;
const imgEyeOff = `${assetPathPrefix}/eye-off.svg`;
const imgArrowRight = `${assetPathPrefix}/arrow-right.svg`;

export default function WelcomeToYeschef() {
  return (
    <div className="bg-[#f8f5ec] content-stretch flex flex-col items-start overflow-clip relative rounded-[32px] size-full" data-node-id="4:1235" data-name="Welcome to Yeschef">
      <div className="content-stretch flex h-[50px] items-center justify-between overflow-clip px-[28px] relative shrink-0 w-[402px]" data-node-id="4:1236" data-name="Status bar">
        <p className="[word-break:break-word] font-['Inter:Semi_Bold'] font-semibold leading-[normal] not-italic relative shrink-0 text-[#263b2e] text-[14px] whitespace-nowrap" data-node-id="4:1237">
          9:41
        </p>
        <div className="content-stretch flex gap-[5px] items-center overflow-clip relative shrink-0" data-node-id="4:1238" data-name="Device status">
          <div className="relative shrink-0 size-[17px]" data-node-id="4:1239" data-name="ios-signal">
            <img alt="" className="absolute block inset-0 max-w-none size-full" src={imgIosSignal} />
          </div>
          <div className="relative shrink-0 size-[17px]" data-node-id="4:1241" data-name="ios-wifi-signal">
            <img alt="" className="absolute block inset-0 max-w-none size-full" src={imgIosWifiSignal} />
          </div>
          <div className="h-[17px] relative shrink-0 w-[24px]" data-node-id="4:1243" data-name="ios-battery-full">
            <img alt="" className="absolute block inset-0 max-w-none size-full" src={imgIosBatteryFull} />
          </div>
        </div>
      </div>
      <div className="content-stretch flex flex-col items-start min-h-[904px] overflow-clip relative shrink-0 w-[402px]" data-node-id="4:1245" data-name="Page content">
        <div className="bg-[#e7eccd] content-stretch flex flex-col h-[220px] items-center overflow-clip relative shrink-0 w-full" data-node-id="6:237" data-name="Chef header">
          <div className="absolute h-[213.8px] left-[106px] top-[10px] w-[190px]" data-node-id="6:238" data-name="Basil the chef">
            <img alt="" className="absolute block inset-0 max-w-none size-full" src={imgBasilTheChef} />
          </div>
          <div className="absolute flex h-[51.376px] items-center justify-center left-[18px] top-[66.08px] w-[116.911px]" data-node-id="6:264">
            <div className="-rotate-8 flex-none">
              <div className="bg-[#fffef8] content-stretch flex items-start overflow-clip px-[12px] py-[9px] relative rounded-[20px]" data-name="Hello note">
                <p className="[word-break:break-word] font-['Fraunces:Regular'] font-normal leading-[normal] relative shrink-0 text-[#386347] text-[15px] whitespace-nowrap" data-node-id="6:265" style={{ fontVariationSettings: '"SOFT" 0, "WONK" 1' }}>{`Hi, I'm Basil!`}</p>
              </div>
            </div>
          </div>
          <div className="absolute flex items-center justify-center left-[22px] size-[41.641px] top-[129.12px]" data-node-id="6:266">
            <div className="-rotate-15 flex-none">
              <div className="content-stretch flex items-start overflow-clip relative" data-name="Herb Yeschef">
                <div className="relative shrink-0 size-[34px]" data-node-id="6:267" data-name="leaf">
                  <img alt="" className="absolute block inset-0 max-w-none size-full" src={imgLeaf} />
                </div>
              </div>
            </div>
          </div>
          <div className="absolute flex h-[40.181px] items-center justify-center left-[229.55px] top-[185px] w-[120.28px]" data-node-id="6:269">
            <div className="flex-none rotate-6">
              <div className="bg-[#f1e5b4] content-stretch flex items-start overflow-clip px-[10px] py-[8px] relative rounded-[8px]" data-name="Kitchen note">
                <p className="[word-break:break-word] font-['Inter:Semi_Bold'] font-semibold leading-[normal] not-italic relative shrink-0 text-[#263b2e] text-[10px] whitespace-nowrap" data-node-id="6:270">
                  Your little sous-chef
                </p>
              </div>
            </div>
          </div>
        </div>
        <div className="bg-[#dfe2d3] h-px relative shrink-0 w-full" data-node-id="6:271" data-name="Divider" />
        <div className="content-stretch flex flex-col gap-[24px] items-start overflow-clip pb-[24px] pt-[20px] px-[24px] relative shrink-0 w-full" data-node-id="6:272" data-name="Inner content">
          <div className="content-stretch flex gap-[7px] items-center justify-center overflow-clip relative shrink-0 w-full" data-node-id="4:1246" data-name="Brand">
            <div className="relative shrink-0 size-[27px]" data-node-id="4:1247" data-name="sprout">
              <img alt="" className="absolute block inset-0 max-w-none size-full" src={imgSprout} />
            </div>
            <p className="[word-break:break-word] font-['Fraunces:SemiBold'] font-semibold leading-[normal] relative shrink-0 text-[#386347] text-[34px] tracking-[-1px] whitespace-nowrap" data-node-id="4:1249" style={{ fontVariationSettings: '"SOFT" 0, "WONK" 1' }}>
              Yeschef
            </p>
          </div>
          <div className="[word-break:break-word] content-stretch flex flex-col gap-[10px] items-center overflow-clip relative shrink-0 text-center w-full" data-node-id="4:1250" data-name="Welcome story">
            <div className="font-['Fraunces:SemiBold'] font-semibold leading-[0] relative shrink-0 text-[#263b2e] text-[35px] tracking-[-1px] w-full" data-node-id="4:1287" style={{ fontVariationSettings: '"SOFT" 0, "WONK" 1' }}>
              <p className="leading-[1.08] mb-0">A little planning.</p>
              <p className="leading-[1.08]">A lot of good food.</p>
            </div>
            <p className="font-['Inter:Regular'] font-normal leading-[1.45] not-italic relative shrink-0 text-[#73796b] text-[14px] w-full" data-node-id="4:1288">
              Meals for your people, a list for your shop, and a friendly chef along the way.
            </p>
          </div>
          <div className="content-stretch flex flex-col gap-[14px] items-start overflow-clip relative shrink-0 w-full" data-node-id="4:1289" data-name="Sign in">
            <p className="[word-break:break-word] font-['Inter:Bold'] font-bold leading-[normal] not-italic relative shrink-0 text-[#386347] text-[10px] tracking-[1.5px] uppercase whitespace-nowrap" data-node-id="4:1290">
              Your kitchen is waiting
            </p>
            <div className="content-stretch flex flex-col gap-[7px] items-start overflow-clip relative shrink-0 w-full" data-node-id="4:1291" data-name="Sign-in field">
              <p className="[word-break:break-word] font-['Inter:Semi_Bold'] font-semibold leading-[normal] not-italic relative shrink-0 text-[#263b2e] text-[12px] whitespace-nowrap" data-node-id="4:1292">
                Email address
              </p>
              <div className="bg-[#fffef8] border border-[#dfe2d3] border-solid content-stretch flex h-[49px] items-center justify-between overflow-clip px-[16px] relative rounded-[10px] shrink-0 w-full" data-node-id="4:1293" data-name="Input">
                <p className="[word-break:break-word] font-['Inter:Regular'] font-normal leading-[normal] not-italic relative shrink-0 text-[#73796b] text-[13px] whitespace-nowrap" data-node-id="4:1294">
                  alex.morgan@email.com
                </p>
              </div>
            </div>
            <div className="content-stretch flex flex-col gap-[7px] items-start overflow-clip relative shrink-0 w-full" data-node-id="4:1295" data-name="Sign-in field">
              <p className="[word-break:break-word] font-['Inter:Semi_Bold'] font-semibold leading-[normal] not-italic relative shrink-0 text-[#263b2e] text-[12px] whitespace-nowrap" data-node-id="4:1296">
                Password
              </p>
              <div className="bg-[#fffef8] border border-[#dfe2d3] border-solid content-stretch flex h-[49px] items-center justify-between overflow-clip px-[16px] relative rounded-[10px] shrink-0 w-full" data-node-id="4:1297" data-name="Input">
                <p className="[word-break:break-word] font-['Inter:Regular'] font-normal leading-[normal] not-italic relative shrink-0 text-[#73796b] text-[13px] whitespace-nowrap" data-node-id="4:1298">
                  ••••••••••••
                </p>
                <div className="relative shrink-0 size-[17px]" data-node-id="4:1299" data-name="eye-off">
                  <img alt="" className="absolute block inset-0 max-w-none size-full" src={imgEyeOff} />
                </div>
              </div>
            </div>
            <div className="content-stretch flex items-start justify-end overflow-clip relative shrink-0 w-full" data-node-id="4:1301" data-name="Account help">
              <p className="[word-break:break-word] font-['Inter:Medium'] font-medium leading-[normal] not-italic relative shrink-0 text-[#386347] text-[12px] whitespace-nowrap" data-node-id="4:1302">
                Forgot password?
              </p>
            </div>
            <div className="bg-[#386347] border border-[#386347] border-solid content-stretch flex gap-[10px] h-[52px] items-center justify-center overflow-clip relative rounded-[100px] shrink-0 w-full" data-node-id="4:1303" data-name="Button">
              <div className="relative shrink-0 size-[18px]" data-node-id="4:1304" data-name="arrow-right">
                <img alt="" className="absolute block inset-0 max-w-none size-full" src={imgArrowRight} />
              </div>
              <p className="[word-break:break-word] font-['Inter:Semi_Bold'] font-semibold leading-[normal] not-italic relative shrink-0 text-[14px] text-white whitespace-nowrap" data-node-id="4:1306">
                Step into my kitchen
              </p>
            </div>
            <div className="bg-[#fffef8] border border-[#dfe2d3] border-solid content-stretch flex h-[52px] items-center justify-center overflow-clip relative rounded-[100px] shrink-0 w-full" data-node-id="4:1307" data-name="Button">
              <p className="[word-break:break-word] font-['Inter:Semi_Bold'] font-semibold leading-[normal] not-italic relative shrink-0 text-[#386347] text-[14px] whitespace-nowrap" data-node-id="4:1308">
                Continue with Apple
              </p>
            </div>
            <p className="[word-break:break-word] font-['Inter:Regular'] font-normal leading-[normal] min-w-full not-italic relative shrink-0 text-[#73796b] text-[12px] text-center w-[min-content] whitespace-pre-wrap" data-node-id="4:1309">{`New here?   Create your free kitchen →`}</p>
            <p className="[word-break:break-word] font-['Inter:Regular'] font-normal leading-[1.45] min-w-full not-italic relative shrink-0 text-[#73796b] text-[10px] text-center w-[min-content]" data-node-id="4:1310">{`By continuing, you agree to our Terms & Privacy Policy.`}</p>
          </div>
        </div>
      </div>
      <div className="content-stretch flex h-[26px] items-center justify-center overflow-clip relative shrink-0 w-full" data-node-id="4:1311" data-name="Gesture area">
        <div className="bg-[#263b2e] h-[4px] relative rounded-[100px] shrink-0 w-[122px]" data-node-id="4:1312" data-name="Home indicator" />
      </div>
    </div>
  );
}