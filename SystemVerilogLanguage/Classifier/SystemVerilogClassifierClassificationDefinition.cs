//------------------------------------------------------------------------------
// <copyright file="SystemVerilogClassifierClassificationDefinition.cs" company="Company">
//     Copyright (c) Company.  All rights reserved.
// </copyright>
//------------------------------------------------------------------------------

using System.ComponentModel.Composition;
using Microsoft.VisualStudio.Text.Classification;
using Microsoft.VisualStudio.Utilities;

namespace SystemVerilogLanguage
{
    /// <summary>
    /// Classification type definition exports for SystemVerilogClassifier
    /// </summary>
    internal static class SystemVerilogClassificationDefinitions
    {
        #region Content Type and File Extension Definitions

        [Export]
        [Name("SystemVerilog")]
        [BaseDefinition("text")]
        internal static ContentTypeDefinition systemVerilogContentTypeDefinition = null;

        [Export]
        [FileExtension(".sv")]
        [ContentType("SystemVerilog")]
        internal static FileExtensionToContentTypeDefinition svFileExtensionDefinition = null;

        [Export]
        [FileExtension(".svh")]
        [ContentType("SystemVerilog")]
        internal static FileExtensionToContentTypeDefinition svhFileExtensionDefinition = null;

        [Export]
        [FileExtension(".v")]
        [ContentType("SystemVerilog")]
        internal static FileExtensionToContentTypeDefinition vFileExtensionDefinition = null;

        [Export]
        [FileExtension(".vh")]
        [ContentType("SystemVerilog")]
        internal static FileExtensionToContentTypeDefinition vhFileExtensionDefinition = null;

        #endregion

        #region Classification Type Definitions

        [Export]
        [Name("SystemVerilog.Keyword")]
        internal static ClassificationTypeDefinition systemVerilogKeywordDefinition = null;

        [Export]
        [Name("SystemVerilog.Identifier")]
        internal static ClassificationTypeDefinition systemVerilogIdentifierDefinition = null;

        #endregion
    }
}
