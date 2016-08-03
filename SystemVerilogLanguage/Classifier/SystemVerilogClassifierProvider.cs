//------------------------------------------------------------------------------
// <copyright file="SystemVerilogClassifierProvider.cs" company="Company">
//     Copyright (c) Company.  All rights reserved.
// </copyright>
//------------------------------------------------------------------------------

using System.ComponentModel.Composition;
using Microsoft.VisualStudio.Text;
using Microsoft.VisualStudio.Text.Classification;
using Microsoft.VisualStudio.Utilities;

namespace SystemVerilogLanguage
{
    [Export(typeof(IClassifierProvider))]
    [ContentType("SystemVerilog")]
    internal sealed class SystemVerilogClassifierProvider : IClassifierProvider
    {
        [Import]
        internal IClassificationTypeRegistryService ClassificationTypeRegistry = null;

        public IClassifier GetClassifier(ITextBuffer buffer)
        {
            return buffer.Properties.GetOrCreateSingletonProperty(() => new SystemVerilogClassifier(buffer, ClassificationTypeRegistry));
        }
    }
}
