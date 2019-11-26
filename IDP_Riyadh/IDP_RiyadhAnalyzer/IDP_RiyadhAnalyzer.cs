using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using IconisUtilities;
using System.ComponentModel;

namespace IDP_TELAnalyzer
{
    [RunInstaller(true)]
    public class IDP_TELAnalyzer : IconisAnalyzer
    {
        protected override void OnAfterInstall(System.Collections.IDictionary savedState)
        {
            base.OnAfterInstall(savedState);
            UnZipFiles(@"D:\Dataprep\IDP\IDP_Riyadh.zip", @"D:\Dataprep\");
        }

        protected override void OnBeforeUninstall(System.Collections.IDictionary savedState)
        {
            base.OnBeforeUninstall(savedState);

            UninstallZipFiles(@"D:\Dataprep\IDP\IDP_Riyadh.zip", @"D:\Dataprep\");
        }

    }
}
