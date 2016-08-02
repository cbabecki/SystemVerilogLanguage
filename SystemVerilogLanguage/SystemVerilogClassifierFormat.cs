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
    /// <summary>
    /// Defines an editor format for the SystemVerilogClassifier type that has a purple background
    /// and is underlined.
    /// </summary>
    [Export(typeof(EditorFormatDefinition))]
    [ClassificationType(ClassificationTypeNames = "SystemVerilogClassification")]
    [Name("SystemVerilogClassification")]
    internal sealed class SystemVerilogFormat : ClassificationFormatDefinition
    {
        /// <summary>
        /// Initializes a new instance of the <see cref="SystemVerilogFormat"/> class.
        /// </summary>
        public SystemVerilogFormat()
        {
            this.DisplayName = "SystemVerilog";
            this.BackgroundColor = Colors.BlueViolet;
            this.TextDecorations = System.Windows.TextDecorations.Underline;
        }
    }
}
