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
    /// <summary>
    /// Classifier provider. It adds the classifier to the set of classifiers.
    /// </summary>
    [Export(typeof(IClassifierProvider))]
    [ContentType("SystemVerilog")] // This classifier applies to all text files.
    internal class SystemVerilogClassifierProvider : IClassifierProvider
    {
        /// <summary>
        /// Classification registry to be used for getting a reference
        /// to the custom classification type later.
        /// </summary>
        [Import]
        # pragma warning disable 649
        private IClassificationTypeRegistryService classificationRegistry;
        # pragma warning restore 649

        #region IClassifierProvider

        /// <summary>
        /// Gets a classifier for the given text buffer.
        /// </summary>
        /// <param name="buffer">The <see cref="ITextBuffer"/> to classify.</param>
        /// <returns>A classifier for the text buffer, or null if the provider cannot do so in its current state.</returns>
        public IClassifier GetClassifier(ITextBuffer buffer)
        {
            return buffer.Properties.GetOrCreateSingletonProperty<SystemVerilogClassifier>(creator: () => new SystemVerilogClassifier(this.classificationRegistry));
        }

        #endregion
    }
}
