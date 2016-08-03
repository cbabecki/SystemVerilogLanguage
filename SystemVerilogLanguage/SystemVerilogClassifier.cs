//------------------------------------------------------------------------------
// <copyright file="SystemVerilogClassifier.cs" company="Company">
//     Copyright (c) Company.  All rights reserved.
// </copyright>
//------------------------------------------------------------------------------

using System;
using System.Diagnostics;
using System.Collections.Generic;
using Microsoft.VisualStudio.Text;
using Microsoft.VisualStudio.Text.Classification;
using Antlr4.Runtime;
using Antlr4.Runtime.Tree;

namespace SystemVerilogLanguage
{
    /// <summary>
    /// Classifier that classifies all text as an instance of the "SystemVerilogClassifier" classification type.
    /// </summary>
    internal class SystemVerilogClassifier : IClassifier
    {
        /// <summary>
        /// Classification type registry.
        /// </summary>
        private IClassificationTypeRegistryService typeRegistry;

        /// <summary>
        /// Initializes a new instance of the <see cref="SystemVerilogClassifier"/> class.
        /// </summary>
        /// <param name="registry">Classification registry.</param>
        internal SystemVerilogClassifier(IClassificationTypeRegistryService registry)
        {
            this.typeRegistry = registry;
        }

        #region IClassifier

        /// <summary>
        /// An event that occurs when the classification of a span of text has changed.
        /// </summary>
        /// <remarks>
        /// This event gets raised if a non-text change would affect the classification in some way,
        /// for example typing /* would cause the classification to change in C# without directly
        /// affecting the span.
        /// </remarks>
        # pragma warning disable 67
        public event EventHandler<ClassificationChangedEventArgs> ClassificationChanged;
        # pragma warning restore 67

        /// <summary>
        /// Gets all the <see cref="ClassificationSpan"/> objects that intersect with the given range of text.
        /// </summary>
        /// <remarks>
        /// This method scans the given SnapshotSpan for potential matches for this classification.
        /// In this instance, it classifies everything and returns each span as a new ClassificationSpan.
        /// </remarks>
        /// <param name="span">The span currently being classified.</param>
        /// <returns>A list of ClassificationSpans that represent spans identified to be of this classification.</returns>
        public IList<ClassificationSpan> GetClassificationSpans(SnapshotSpan span)
        {
            Debug.WriteLine(String.Format("Parsing: {0}", span.GetText()));
            var lexer  = new SystemVerilogLexer(new AntlrInputStream(span.GetText()));
            var tokens = new CommonTokenStream(lexer);
            var parser = new SystemVerilogParser(tokens);

            // Walk it and attach our listener
            var walker   = new ParseTreeWalker();
            var listener = new SystemVerilogClassifierListener(typeRegistry, span);
            walker.Walk(listener, parser.source_text());

            return listener.spanList;
        }

        #endregion
    }
}
