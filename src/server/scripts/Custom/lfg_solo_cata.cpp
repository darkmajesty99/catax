#include "Config.h"
#include "LFGMgr.h"
#include "ScriptMgr.h"

class lfg_solo_cata : public WorldScript
{
   public:
    lfg_solo_cata() : WorldScript("lfg_solo_cata") {}

    void OnStartup() override
    {
        if (sConfigMgr->GetBoolDefault("SoloLFG.Enable", false)) sLFGMgr->ToggleSoloLFG();
    }
};

void AddSC_lfg_solo_cata() { new lfg_solo_cata(); }
