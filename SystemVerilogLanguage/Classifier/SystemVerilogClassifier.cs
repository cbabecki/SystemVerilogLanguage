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
    internal class SystemVerilogClassifier : IClassifier
    {
        private ITextBuffer buffer;
        private IClassificationTypeRegistryService typeRegistry;

        # pragma warning disable 67
        public event EventHandler<ClassificationChangedEventArgs> ClassificationChanged;
        # pragma warning restore 67

        internal SystemVerilogClassifier(ITextBuffer buffer,
                                         IClassificationTypeRegistryService typeRegistry)
        {
            this.buffer       = buffer;
            this.typeRegistry = typeRegistry;
        }

        public IList<ClassificationSpan> GetClassificationSpans(SnapshotSpan span)
        {
            Debug.WriteLine(string.Format("Parsing: {0}", span.GetText()));
            Debug.WriteLine(string.Format("Bounds:  {0}--{1}", span.Start.Position, span.End.Position));

            // Allocate the SystemVerilog lexer/parser
            var lexer = new SystemVerilogLexer(new AntlrInputStream(span.Snapshot.GetText()));
            var tokens = new CommonTokenStream(lexer);
            var parser = new SystemVerilogParser(tokens);

            // Attach our listener and walk the parse tree
            var walker = new ParseTreeWalker();
            var listener = new SystemVerilogClassifierListener(typeRegistry, span);
            walker.Walk(listener, parser.source_text());

            return listener.spanList;
        }
    }
}
