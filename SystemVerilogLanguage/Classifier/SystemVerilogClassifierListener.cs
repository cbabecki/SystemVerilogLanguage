using System.Diagnostics;
using System.Collections.Generic;
using Microsoft.VisualStudio.Text;
using Microsoft.VisualStudio.Text.Classification;
using Antlr4.Runtime;

namespace SystemVerilogLanguage
{
    internal class SystemVerilogClassifierListener : SystemVerilogBaseListener
    {
        /// <summary>
        /// Classification type registry.
        /// </summary>
        private IClassificationTypeRegistryService typeRegistry;

        /// <summary>
        /// The full text snapshot being traversed by this listener.
        /// </summary>
        private ITextSnapshot snapshot;

        /// <summary>
        /// The starting and ending character positions of the original span.
        /// </summary>
        private int start;
        private int end;

        /// <summary>
        /// List of tagged spans.  Built as the listener walks a parse tree.
        /// </summary>
        public List<ClassificationSpan> spanList { get; }

        /// <summary>
        /// Initializes a new instance of the <see cref="SystemVerilogClassifierListener"/> class.
        /// </summary>
        /// <param name="registry">Classification registry.</param>
        internal SystemVerilogClassifierListener(IClassificationTypeRegistryService typeRegistry, SnapshotSpan snapshot)
        {
            this.snapshot = snapshot.Snapshot;
            this.start = snapshot.Start.Position;
            this.end = snapshot.End.Position;
            this.typeRegistry = typeRegistry;
            spanList = new List<ClassificationSpan>();
        }

        private void AddSpan(ParserRuleContext context, IClassificationType classification)
        {
            if (context.Start.StartIndex >= start && context.Stop.StopIndex <= end)
            {
                var startPoint = new SnapshotPoint(snapshot, context.Start.StartIndex);
                var endPoint = new SnapshotPoint(snapshot, context.Stop.StopIndex + 1);

                Debug.WriteLine(string.Format("Start: {0}, End: {1}", startPoint.Position, endPoint.Position - 1));
                Debug.WriteLine(string.Format("Text: {0}", new SnapshotSpan(startPoint, endPoint).GetText()));
                spanList.Add(new ClassificationSpan(new SnapshotSpan(startPoint, endPoint), classification));
            }
        }

        public override void ExitModule_keyword(SystemVerilogParser.Module_keywordContext context)
        {
            AddSpan(context, typeRegistry.GetClassificationType("SystemVerilog.Keyword"));
        }

        public override void ExitIdentifier(SystemVerilogParser.IdentifierContext context)
        {
            AddSpan(context, typeRegistry.GetClassificationType("SystemVerilog.Identifier"));
        }
    }
}
