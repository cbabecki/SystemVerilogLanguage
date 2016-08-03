//------------------------------------------------------------------------------
// <copyright file="SystemVerilogClassifierFormat.cs" company="Company">
//     Copyright (c) Company.  All rights reserved.
// </copyright>
//------------------------------------------------------------------------------

using System.ComponentModel.Composition;
using System.Windows.Media;
using Microsoft.VisualStudio.Text.Classification;
using Microsoft.VisualStudio.Utilities;

namespace SystemVerilogLanguage
{
    [Export(typeof(EditorFormatDefinition))]
    [ClassificationType(ClassificationTypeNames = "SystemVerilog.Keyword")]
    [Name("SystemVerilog.Keyword")]
    internal sealed class SystemVerilogKeywordFormat : ClassificationFormatDefinition
    {
        public SystemVerilogKeywordFormat()
        {
            this.DisplayName = "SystemVerilog Keyword";
            this.ForegroundColor = Color.FromRgb(86, 156, 214);
        }
    }

    [Export(typeof(EditorFormatDefinition))]
    [ClassificationType(ClassificationTypeNames = "SystemVerilog.Identifier")]
    [Name("SystemVerilog.Identifier")]
    internal sealed class SystemVerilogIdentiferFormat : ClassificationFormatDefinition
    {
        public SystemVerilogIdentiferFormat()
        {
            this.DisplayName = "SystemVerilog Identifer";
            this.ForegroundColor = Color.FromRgb(78, 201, 176);
        }
    }
}
