import {
  Component,
  Entry,
  Column,
  Text,
  ScrollView,
  Color,
  ref,
  computed,
  onMounted,
} from '@kit/arkui';
import MarkdownIt from 'markdown-it';
import { Loading } from '../components/Loading';
import { fetchChangelog } from '../common/api';

@Entry
@Component
export struct ChangelogPage {
  private changelog = ref<string>('');
  private md = new MarkdownIt({
    html: false,
    linkify: true,
    typographer: true,
  });

  private renderedMarkdown = computed(() => this.md.render(this.changelog.value));

  @Builder
  build() {
    Column({ width: '100%', maxWidth: 1024, padding: 16 }) {
      // 页面标题
      Column({
        backgroundColor: Color('#f5f3ff'),
        padding: 16,
        borderRadius: 16,
        marginBottom: 32,
      }) {
        Text('更新日志').fontSize(24).fontWeight('bold').color(Color('#4f46e5'))
      }

      // 内容
      if (!this.changelog.value) {
        Loading()
      } else {
        ScrollView() {
          Text({ html: this.renderedMarkdown.value })
        }
      }
    }
  }

  private addClassToRule(ruleName: string, className: string) {
    const originalRule = this.md.renderer.rules[ruleName];
    this.md.renderer.rules[ruleName] = (tokens, idx, options, env, self) => {
      tokens[idx]?.attrJoin('class', className);
      return originalRule ? originalRule(tokens, idx, options, env, self) : self.renderToken(tokens, idx, options);
    };
  }

  onMounted(async () => {
  // 自定义 markdown 渲染规则
  const headingMap: Record<string, string> = {
  h1: 'text-2xl font-bold mb-4 border-b pb-2 text-indigo-700',
  h2: 'text-xl font-semibold mb-3 pt-2 text-indigo-600',
  h3: 'text-lg font-medium mb-2 pt-1 text-indigo-500',
};
  const originalHeading = this.md.renderer.rules['heading_open'];
  this.md.renderer.rules['heading_open'] = (tokens, idx, options, env, self) => {
  const tag = tokens[idx]?.tag;
  tokens[idx]?.attrJoin('class', tag && headingMap[tag] ? headingMap[tag] : '');
  return originalHeading ? originalHeading(tokens, idx, options, env, self) : self.renderToken(tokens, idx, options);
};

  this.addClassToRule('paragraph_open', 'mb-3 leading-relaxed');
  this.addClassToRule('link_open', 'text-blue-600 hover:underline');
  this.addClassToRule('list_item_open', 'mb-1');
  this.addClassToRule('bullet_list_open', 'list-disc pl-5 mb-3');
  this.addClassToRule('ordered_list_open', 'list-decimal pl-5 mb-3');
  this.addClassToRule('code_inline', 'bg-neutral-100 px-1.5 py-0.5 rounded border font-mono text-sm');
  this.addClassToRule('fence', 'rounded-md overflow-x-auto text-sm font-mono');
  this.addClassToRule('blockquote_open', 'border-l-4 border-indigo-500 pl-4 italic text-gray-700 my-4');
  this.addClassToRule('table_open', 'w-full text-left border-collapse my-4');
  this.addClassToRule('th_open', 'px-4 py-2 bg-gray-100 border font-semibold');
  this.addClassToRule('td_open', 'px-4 py-2 border');

  // 获取 changelog
  this.changelog.value = await fetchChangelog();
});
}
