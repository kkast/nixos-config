{ package, lib }: 
     let
        createChromiumExtensionFor = browserVersion: { id, sha256, version }:
          {
            inherit id;
            crxPath = builtins.fetchurl {
              url = "https://clients2.google.com/service/update2/crx?response=redirect&acceptformat=crx2,crx3&prodversion=${browserVersion}&x=id%3D${id}%26installsource%3Dondemand%26uc";
              name = "${id}.crx";
              inherit sha256;
            };
            inherit version;
          };
        createChromiumExtension = createChromiumExtensionFor (lib.versions.major package.version);
      in
{
  enable = true;
  inherit package;

  extensions =
    [
      (createChromiumExtension {
        # ublock origin
        id = "cjpalhdlnbpafiamejdnhcphjbkeiagm";
        sha256 = "sha256:0fcrpxv3y5n72znwgvbaa223hyb464vs2s2bjynyk26sqq09pg4j";
        version = "1.44.4";
      })
      (createChromiumExtension {
        # vimium
        id = "dbepggeogbaibhgnhhndojpepiihcmeb";
        sha256 = "sha256:00qhbs41gx71q026xaflgwzzridfw1sx3i9yah45cyawv8q7ziic";
        version = "1.67.4";
      })
      (createChromiumExtension {
        # 1password
        id = "aeblfdkhhhdcdjpifhhbdiojplfjncoa";
        sha256 = "sha256:1jg95wy190hfcpg5vmc7ynwbf831h4bycxlkf41anc66ap8yv58l";
        version = "2.5.1";
      })
      (createChromiumExtension {
        # Polkadot
        id = "mopnmbcafieddcagagdcbnhejhlodfdd";
        sha256 = "sha256:1wz50lbi6p182pkr7ysifzyb1inxn5ahvzmi6n5syx87xgrknns5";
        version = "0.44.1";
      })
      (createChromiumExtension {
        # Empty new tab
        id = "dpjamkmjmigaoobjbekmfgabipmfilij";
        sha256 = "sha256:1fv65lfrh1jh9rz3wq26ri4hzkv9n4j563v1arzwys1f8g015fks";
        version = "1.2.0";
      })
      (createChromiumExtension {
        # DF Tube
        id = "mjdepdfccjgcndkmemponafgioodelna";
        sha256 = "sha256:0a4qiq91ypzgnanqj9y4pycij6467f77i1y429rrvka2fkaswf1g";
        version = "1.13.504";
      })
      (createChromiumExtension {
        # Old reddit redirect
        id = "dneaehbmnbhcippjikoajpoabadpodje";
        sha256 = "sha256:194gf0b835nyi5yx4brlywrd6bbd3kal4nn45hxxwml2l0swmncx";
        version = "1.6.1";
      })
      (createChromiumExtension {
        # Less distracting reddit
        id = "ililagkodjpoopfjphagpamfhfbamppa";
        sha256 = "sha256:02prnfphg59nmwzimi74s35k41yzbdiqppgy7xdj6kg92vllms82";
        version = "0.5";
      })
      (createChromiumExtension {
        # LeechBlock
        id = "blaaajhemilngeeffpbfkdjjoefldkok";
        sha256 = "sha256:05r2cqdi58m022m04bs05syi0fm8npz5xcvcncl2hp8zqxdlvly9";
        version = "1.5.2";
      })
   ];
}
