﻿using System;
using System.IO;
using System.Text;
using System.Collections.Generic;
using PluginCore.Localization;
using PluginCore.Managers;
using PluginCore.Helpers;

namespace FlashDevelop.Managers
{
    class CleanupManager
    {
        private const String coloringStart = "<!-- COLORING_START -->";
        private const String coloringEnd = "<!-- COLORING_END -->";

        /// <summary>
        /// Reverts the language config files fully or keeping the coloring.
        /// </summary>
        public static void RevertConfiguration(Boolean everything)
        {
            String appSettingDir = Path.Combine(PathHelper.AppDir, "Settings");
            String appLanguageDir = Path.Combine(appSettingDir, "Languages");
            String userLanguageDir = Path.Combine(PathHelper.SettingDir, "Languages");
            if (everything) FolderHelper.CopyFolder(appLanguageDir, userLanguageDir);
            else
            {
                String[] userFiles = Directory.GetFiles(userLanguageDir);
                foreach (String userFile in userFiles)
                {
                    String appFile = Path.Combine(appLanguageDir, Path.GetFileName(userFile));
                    if (File.Exists(appFile))
                    {
                        try
                        {
                            String appFileContents = FileHelper.ReadFile(appFile);
                            String userFileContents = FileHelper.ReadFile(userFile);
                            Int32 appFileColoringStart = appFileContents.IndexOf(coloringStart);
                            Int32 appFileColoringEnd = appFileContents.IndexOf(coloringEnd);
                            Int32 userFileColoringStart = userFileContents.IndexOf(coloringStart);
                            Int32 userFileColoringEnd = userFileContents.IndexOf(coloringEnd);
                            String replaceTarget = appFileContents.Substring(appFileColoringStart, appFileColoringEnd - appFileColoringStart + coloringEnd.Length);
                            String replaceContent = userFileContents.Substring(userFileColoringStart, userFileColoringEnd - userFileColoringStart + coloringEnd.Length);
                            String finalContent = appFileContents.Replace(replaceTarget, replaceContent);
                            FileHelper.WriteFile(userFile, finalContent, Encoding.UTF8);
                        }
                        catch (Exception ex)
                        {
                            String desc = TextHelper.GetString("Info.ColoringTagsMissing");
                            ErrorManager.ShowError(desc, ex);
                        }
                    }
                }
            }
        }
    }
}
