using System.Diagnostics;
using System.Collections.Generic;
using Microsoft.VisualStudio.Text;
using Microsoft.VisualStudio.Text.Classification;

namespace SystemVerilogLanguage
{
    internal class SystemVerilogClassifierListener : SystemVerilogBaseListener
    {
        /// <summary>
        /// Classification type registry.
        /// </summary>
        private IClassificationTypeRegistryService typeRegistry;

        /// <summary>
        /// The full SnapshotSpan being traversed by this listener.
        /// </summary>
        private SnapshotSpan span;

        /// <summary>
        /// List of tagged spans.  Built as the listener walks a parse tree.
        /// </summary>
        public List<ClassificationSpan> spanList { get; }

        /// <summary>
        /// Initializes a new instance of the <see cref="SystemVerilogClassifierListener"/> class.
        /// </summary>
        /// <param name="registry">Classification registry.</param>
        internal SystemVerilogClassifierListener(IClassificationTypeRegistryService registry, SnapshotSpan span)
        {
            typeRegistry = registry;
            spanList = new List<ClassificationSpan>();
        }

        public override void ExitModule_keyword(SystemVerilogParser.Module_keywordContext context)
        {
            Debug.WriteLine("Start: {0}, End: {1}", context.Start.StartIndex, context.Stop.StopIndex);
            spanList.Add(new ClassificationSpan(new SnapshotSpan(span.Snapshot, Span.FromBounds(context.Start.StartIndex, context.Stop.StopIndex)), typeRegistry.GetClassificationType("SystemVerilog")));
        }
    }
}
