@Component
export struct AppSearchList {
  // 搜索相关状态
  @State searchContent: string = ''
  @State searchKey: string = 'name'
  @State exactMatch: boolean = false
  @State excludeHuawei: boolean = false
  @State excludeAtomic: boolean = false
  
  // 排序相关状态
  @State sortKey: string = ''
  @State sortDesc: boolean = true
  
  // 分页相关状态
  @State currentPage: number = 1
  @State pageSize: number = 20
  @State totalCount: number = 0
  @State jumpPage: number | null = null
  
  // 数据状态
  @State apps: AppItem[] = []
  @State loading: boolean = false
  @State loaded: boolean = false
  
  // 计算属性
  get totalPages(): number {
    return Math.max(1, Math.ceil(this.totalCount / this.pageSize))
  }
  
  get visiblePages(): number[] {
    const pages: number[] = []
    const total = this.totalPages
    const current = this.currentPage
    const range = 5
    
    const start = Math.max(1, current - range)
    const end = Math.min(total, current + range)
    
    for (let i = start; i <= end; i++) {
      pages.push(i)
    }
    return pages
  }
  
  aboutToAppear() {
    if (!this.loaded) {
      this.loadApps()
    }
  }
  
  // 搜索处理
  handleSearch() {
    this.currentPage = 1
    this.loadApps()
  }
  
  // 重置搜索
  resetSearch() {
    this.searchContent = ''
    this.searchKey = 'name'
    this.exactMatch = false
    this.excludeHuawei = false
    this.excludeAtomic = false
    this.sortKey = ''
    this.sortDesc = true
    this.currentPage = 1
    this.loadApps()
  }
  
  // 排序处理
  sortBy(key: string) {
    if (this.sortKey === key) {
      this.sortDesc = !this.sortDesc
    } else {
      this.sortKey = key
      this.sortDesc = true
    }
    this.currentPage = 1
    this.loadApps()
  }
  
  // 分页跳转
  goToPage(page: number) {
    if (page >= 1 && page <= this.totalPages) {
      this.currentPage = page
      this.loadApps()
    }
  }
  
  jumpToPage() {
    if (this.jumpPage && this.jumpPage >= 1 && this.jumpPage <= this.totalPages) {
      this.goToPage(this.jumpPage)
      this.jumpPage = null
    }
  }
  
  // 应用详情跳转
  goToAppDetail(appId: string) {
    // HarmonyOS 路由跳转逻辑
    // router.push({ url: 'pages/AppDetail', params: { appId } })
  }
  
  // 开发者筛选
  filteredByDeveloper(developerName: string) {
    if (!developerName) return
    this.searchKey = 'developer_name'
    this.searchContent = developerName
    this.handleSearch()
  }
  
  // 数据加载
  async loadApps() {
    this.loading = true
    this.apps = []
    
    try {
      const params: AppListParams = this.getCurrentParams()
      const result = await this.fetchAppList(params)
      this.apps = result.data
      this.totalCount = result.total_count
    } catch (error) {
      console.error('加载应用列表失败:', error)
    } finally {
      this.loading = false
      this.loaded = true
    }
  }
  
  getCurrentParams(): AppListParams {
    return {
      page: this.currentPage,
      page_size: this.pageSize,
      sort: this.sortKey,
      desc: this.sortDesc,
      search_key: this.searchContent ? this.searchKey : undefined,
      search_value: this.searchContent || undefined,
      search_exact: this.searchContent ? this.exactMatch : undefined,
      exclude_huawei: this.excludeHuawei || undefined,
      exclude_atomic: this.excludeAtomic || undefined,
    }
  }
  
  // 工具函数
  formatNumber(num: number): string {
    if (num >= 1000000) {
      return (num / 1000000).toFixed(1) + 'M'
    } else if (num >= 1000) {
      return (num / 1000).toFixed(1) + 'K'
    }
    return num.toString()
  }
  
  formatSize(bytes: number): string {
    const sizes = ['B', 'KB', 'MB', 'GB']
    if (bytes === 0) return '0 B'
    const i = Math.floor(Math.log(bytes) / Math.log(1024))
    return Math.round(bytes / Math.pow(1024, i) * 100) / 100 + ' ' + sizes[i]
  }
  
  formatDate(dateString: string): string {
    if (!dateString) return '-'
    const date = new Date(dateString)
    return `${date.getMonth() + 1}/${date.getDate()} ${date.getHours()}:${date.getMinutes().toString().padStart(2, '0')}`
  }
  
  // API调用 - 需要根据实际API实现
  async fetchAppList(params: AppListParams): Promise<{ data: AppItem[], total_count: number }> {
    // 实现API调用逻辑
    return { data: [], total_count: 0 }
  }
  
  build() {
    Column() {
      // 主容器
      Column() {
        // 搜索区域
        this.buildSearchArea()
        
        // 表格区域
        this.buildTableArea()
        
        // 分页区域
        this.buildPaginationArea()
      }
      .width('100%')
      .padding(24)
      .backgroundColor(this.getGradientBackground())
      .borderRadius(16)
      .border({ 
        width: 1, 
        color: this.getBorderColor() 
      })
      .margin({ bottom: 24 })
      .shadow({ 
        radius: 8, 
        color: '#00000010' 
      })
      
    }
    .width('100%')
    .padding(16)
  }
  
  @Builder buildSearchArea() {
    Column() {
      // 标题
      Text('应用列表')
        .fontSize(18)
        .fontWeight(FontWeight.Medium)
        .fontColor(this.getTextColor('primary'))
        .alignSelf(ItemAlign.Start)
      
      Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Start }) {
        // 第一行：搜索输入 + 下拉 + 按钮
        Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
          // 搜索输入框
          TextInput({ placeholder: '搜索应用', text: this.searchContent })
            .onChange((value: string) => {
              this.searchContent = value
            })
            .layoutWeight(1)
            .minWidth(290)
            .height(40)
            .fontSize(14)
            .padding(12)
            .backgroundColor(this.getInputBackground())
            .placeholderColor(this.getPlaceholderColor())
            .fontColor(this.getTextColor('normal'))
            .border({
              width: 1,
              color: this.getBorderColor('light')
            })
            .borderRadius(8)
          
          // 下拉选择 + 搜索按钮
          Flex({ alignItems: ItemAlign.Center }) {
            // 下拉选择
            Select([
              { value: 'name', content: '应用名称' },
              { value: 'pkg_name', content: '包名' },
              { value: 'description', content: '应用描述' },
              { value: 'app_id', content: '应用ID' },
              { value: 'developer_name', content: '开发者名称' },
              { value: 'dev_en_name', content: '开发者英文名称' },
              { value: 'supplier', content: '供应商' },
              { value: 'kind_name', content: '类型名' },
              { value: 'tag_name', content: '标签名' },
              { value: 'kind_type_name', content: '应用分类' }
            ])
            .value(this.searchKey)
            .onSelect((index: number) => {
              const options = ['name', 'pkg_name', 'description', 'app_id', 'developer_name', 'dev_en_name', 'supplier', 'kind_name', 'tag_name', 'kind_type_name']
              this.searchKey = options[index]
            })
            .layoutWeight(1)
            .height(40)
            .fontSize(14)
            .padding(12)
            .border({
              width: 1,
              color: this.getBorderColor('light')
            })
            .borderRadius(8)
            
            // 搜索按钮
            Button('搜索')
              .width(64)
              .height(40)
              .fontSize(14)
              .fontWeight(FontWeight.Medium)
              .fontColor('#FFFFFF')
              .backgroundColor(this.getButtonGradient())
              .borderRadius(16)
              .onClick(() => this.handleSearch())
          }
          .layoutWeight(1)
          .width('100%')
        }
        .width('100%')
        .wrap(Wrap.NoWrap)
        
        // 第二行：筛选条件 + 重置按钮
        Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
          // 筛选条件
          Flex({ wrap: Wrap.Wrap }) {
            Toggle({ type: ToggleType.Checkbox, isOn: this.excludeHuawei })
              .onChange((value: boolean) => {
                this.excludeHuawei = value
                this.loadApps()
              })
            Text('排除华为应用')
              .fontSize(14)
              .fontColor(this.getTextColor('normal'))
              
            Toggle({ type: ToggleType.Checkbox, isOn: this.excludeAtomic })
              .onChange((value: boolean) => {
                this.excludeAtomic = value
                this.loadApps()
              })
            Text('排除元服务')
              .fontSize(14)
              .fontColor(this.getTextColor('normal'))
              
            Toggle({ type: ToggleType.Checkbox, isOn: this.exactMatch })
              .onChange((value: boolean) => {
                this.exactMatch = value
              })
            Text('精确匹配')
              .fontSize(14)
              .fontColor(this.getTextColor('normal'))
          }
          .layoutWeight(1)
          
          // 重置按钮
          Button('重置搜索')
            .width('100%')
            .maxWidth(120)
            .height(40)
            .fontSize(14)
            .fontWeight(FontWeight.Medium)
            .fontColor('#FFFFFF')
            .backgroundColor(this.getResetButtonColor())
            .borderRadius(16)
            .onClick(() => this.resetSearch())
        }
        .width('100%')
        .margin({ top: 16 })
      }
      .width('100%')
    }
    .width('100%')
    .margin({ bottom: 24 })
  }
  
  @Builder buildTableArea() {
    Column() {
      if (this.loading) {
        // 加载状态
        Text('加载中...')
          .fontSize(14)
          .fontColor(this.getTextColor('accent'))
          .textAlign(TextAlign.Center)
          .padding(16)
      } else if (this.apps.length === 0) {
        // 无数据状态
        Text('暂无数据')
          .fontSize(14)
          .fontColor(this.getTextColor('accent'))
          .textAlign(TextAlign.Center)
          .padding(16)
      } else {
        // 表格头部
        this.buildTableHeader()
        
        // 表格内容
        List({ space: 0 }) {
          ForEach(this.apps, (app: AppItem, index: number) => {
            ListItem() {
              this.buildTableRow(app, index)
            }
          }, (app: AppItem) => app.app_id)
        }
        .width('100%')
        .layoutWeight(1)
      }
    }
    .width('100%')
    .height('100%')
  }
  
  @Builder buildTableHeader() {
    Flex({ alignItems: ItemAlign.Center }) {
      // 序号
      Text('序号')
        .width(40)
        .fontSize(12)
        .fontColor(this.getTextColor('primary'))
        .fontWeight(FontWeight.Medium)
        .textAlign(TextAlign.Start)
      
      // 应用名称
      Text('应用名称')
        .width(160)
        .fontSize(12)
        .fontColor(this.getTextColor('primary'))
        .fontWeight(FontWeight.Medium)
        .textAlign(TextAlign.Start)
      
      // 开发者
      Text('开发者')
        .width(180)
        .fontSize(12)
        .fontColor(this.getTextColor('primary'))
        .fontWeight(FontWeight.Medium)
        .textAlign(TextAlign.Start)
      
      // 分类
      Text('分类')
        .width(140)
        .fontSize(12)
        .fontColor(this.getTextColor('primary'))
        .fontWeight(FontWeight.Medium)
        .textAlign(TextAlign.Start)
      
      // 评分
      Text('评分')
        .width(100)
        .fontSize(12)
        .fontColor(this.getTextColor('primary'))
        .fontWeight(FontWeight.Medium)
        .textAlign(TextAlign.Start)
      
      // 评分数量（可排序）
      Text('评分数量')
        .width(100)
        .fontSize(12)
        .fontColor(this.getTextColor('primary'))
        .fontWeight(FontWeight.Medium)
        .textAlign(TextAlign.Start)
        .onClick(() => this.sortBy('total_star_rating_count'))
      
      // 下载量（可排序）
      Text('下载量')
        .width(100)
        .fontSize(12)
        .fontColor(this.getTextColor('primary'))
        .fontWeight(FontWeight.Medium)
        .textAlign(TextAlign.Start)
        .onClick(() => this.sortBy('download_count'))
      
      // 大小（可排序）
      Text('大小')
        .width(80)
        .fontSize(12)
        .fontColor(this.getTextColor('primary'))
        .fontWeight(FontWeight.Medium)
        .textAlign(TextAlign.Start)
        .onClick(() => this.sortBy('size_bytes'))
      
      // 数据更新时间（可排序）
      Text('数据更新')
        .width(130)
        .fontSize(12)
        .fontColor(this.getTextColor('primary'))
        .fontWeight(FontWeight.Medium)
        .textAlign(TextAlign.Start)
        .onClick(() => this.sortBy('metrics_created_at'))
      
      // 爬取时间（可排序）
      Text('爬取时间')
        .width(130)
        .fontSize(12)
        .fontColor(this.getTextColor('primary'))
        .fontWeight(FontWeight.Medium)
        .textAlign(TextAlign.Start)
        .onClick(() => this.sortBy('created_at'))
      
      // 上架时间（可排序）
      Text('上架时间')
        .width(130)
        .fontSize(12)
        .fontColor(this.getTextColor('primary'))
        .fontWeight(FontWeight.Medium)
        .textAlign(TextAlign.Start)
        .onClick(() => this.sortBy('listed_at'))
    }
    .width('100%')
    .padding(12)
    .backgroundColor(this.getHeaderBackground())
  }
  
  @Builder buildTableRow(app: AppItem, index: number) {
    Flex({ alignItems: ItemAlign.Center }) {
      // 序号
      Text((index + 1 + (this.currentPage - 1) * this.pageSize).toString())
        .width(40)
        .fontSize(14)
        .fontColor(this.getTextColor('normal'))
        .textAlign(TextAlign.Start)
      
      // 应用名称
      Flex({ alignItems: ItemAlign.Center }) {
        Image(app.icon_url)
          .width(20)
          .height(20)
          .margin({ right: 6 })
        Text(app.name)
          .fontSize(14)
          .fontColor(this.getTextColor('normal'))
          .fontWeight(FontWeight.Medium)
          .maxLines(1)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
      }
      .width(160)
      .onClick(() => this.goToAppDetail(app.app_id))
      
      // 开发者
      Text(app.developer_name || '—')
        .width(180)
        .fontSize(14)
        .fontColor(app.developer_name ? '#3B82F6' : this.getTextColor('muted'))
        .textAlign(TextAlign.Start)
        .onClick(() => {
          if (app.developer_name) {
            this.filteredByDeveloper(app.developer_name)
          }
        })
      
      // 分类
      Text(`${app.kind_type_name}-${app.kind_name}-${app.tag_name}`)
        .width(140)
        .fontSize(12)
        .fontColor('#1E40AF')
        .textAlign(TextAlign.Start)
      
      // 评分
      Flex({ alignItems: ItemAlign.Center }) {
        ForEach(new Array(Math.floor(+app.average_rating || 0)), (_, i: number) => {
          Text('★')
            .fontColor('#F59E0B')
        })
        ForEach(new Array(5 - Math.floor(+app.average_rating || 0)), (_, i: number) => {
          Text('☆')
            .fontColor('#D1D5DB')
        })
        Text((+app.average_rating || 0).toString())
          .fontSize(14)
          .fontColor(this.getTextColor('normal'))
          .margin({ left: 4 })
      }
      .width(100)
      
      // 评分数量
      Text(this.formatNumber(app.total_star_rating_count || 0))
        .width(100)
        .fontSize(14)
        .fontColor(this.getTextColor('normal'))
        .textAlign(TextAlign.Start)
      
      // 下载量
      Text(this.formatNumber(app.download_count))
        .width(100)
        .fontSize(14)
        .fontColor(this.getTextColor('normal'))
        .textAlign(TextAlign.Start)
      
      // 大小
      Text(this.formatSize(app.size_bytes || 0))
        .width(80)
        .fontSize(14)
        .fontColor(this.getTextColor('muted'))
        .textAlign(TextAlign.Start)
      
      // 数据更新时间
      Text(this.formatDate(app.metrics_created_at))
        .width(130)
        .fontSize(14)
        .fontColor(this.getTextColor('muted'))
        .textAlign(TextAlign.Start)
      
      // 爬取时间
      Text(this.formatDate(app.created_at))
        .width(130)
        .fontSize(14)
        .fontColor(this.getTextColor('muted'))
        .textAlign(TextAlign.Start)
      
      // 上架时间
      Text(this.formatDate(app.listed_at))
        .width(130)
        .fontSize(14)
        .fontColor(this.getTextColor('muted'))
        .textAlign(TextAlign.Start)
    }
    .width('100%')
    .padding(12)
    .backgroundColor(this.getRowBackground())
    .onClick(() => this.goToAppDetail(app.app_id))
  }
  
  @Builder buildPaginationArea() {
    if (this.totalPages > 1 && !this.loading) {
      Flex({ justifyContent: FlexAlign.Center, alignItems: ItemAlign.Center, wrap: Wrap.Wrap }) {
        // 首页
        if (this.currentPage > 1) {
          Button('首页')
            .padding({ left: 12, right: 12, top: 8, bottom: 8 })
            .fontSize(14)
            .backgroundColor('#DBEAFE')
            .fontColor('#1D4ED8')
            .borderRadius(8)
            .onClick(() => this.goToPage(1))
        }
        
        // 上一页
        Button('上一页')
          .padding({ left: 12, right: 12, top: 8, bottom: 8 })
          .fontSize(14)
          .backgroundColor('#DBEAFE')
          .fontColor('#1D4ED8')
          .borderRadius(8)
          .enabled(this.currentPage !== 1)
          .onClick(() => this.goToPage(this.currentPage - 1))
        
        // 中间页码
        ForEach(this.visiblePages, (page: number) => {
          Button(page.toString())
            .padding({ left: 12, right: 12, top: 8, bottom: 8 })
            .fontSize(14)
            .backgroundColor(page === this.currentPage ? '#BFDBFE' : '#DBEAFE')
            .fontColor(page === this.currentPage ? '#1E3A8A' : '#1D4ED8')
            .fontWeight(page === this.currentPage ? FontWeight.Bold : FontWeight.Normal)
            .borderRadius(8)
            .onClick(() => this.goToPage(page))
        })
        
        // 下一页
        Button('下一页')
          .padding({ left: 12, right: 12, top: 8, bottom: 8 })
          .fontSize(14)
          .backgroundColor('#DBEAFE')
          .fontColor('#1D4ED8')
          .borderRadius(8)
          .enabled(this.currentPage !== this.totalPages)
          .onClick(() => this.goToPage(this.currentPage + 1))
        
        // 尾页
        if (this.currentPage < this.totalPages) {
          Button('尾页')
            .padding({ left: 12, right: 12, top: 8, bottom: 8 })
            .fontSize(14)
            .backgroundColor('#DBEAFE')
            .fontColor('#1D4ED8')
            .borderRadius(8)
            .onClick(() => this.goToPage(this.totalPages))
        }
        
        // 跳转页
        Flex({ alignItems: ItemAlign.Center }) {
          TextInput({ placeholder: '页码', text: this.jumpPage?.toString() || '' })
            .width(64)
            .height(32)
            .fontSize(14)
            .textAlign(TextAlign.Center)
            .type(InputType.Number)
            .onChange((value: string) => {
              this.jumpPage = value ? parseInt(value) : null
            })
          Button('跳转')
            .padding({ left: 12, right: 12, top: 8, bottom: 8 })
            .fontSize(14)
            .backgroundColor('#3B82F6')
            .fontColor('#FFFFFF')
            .borderRadius(8)
            .onClick(() => this.jumpToPage())
        }
        .margin({ left: 8 })
      }
      .width('100%')
      .margin({ top: 24 })
    }
  }
  
  // 样式工具函数
  getGradientBackground(): ResourceColor {
    // 根据主题返回不同的渐变背景
    return '#FFFBEB' // 浅色主题
  }
  
  getBorderColor(type: string = 'normal'): ResourceColor {
    const colors = {
      normal: '#FCD34D',
      light: '#FDE68A'
    }
    return colors[type] || colors.normal
  }
  
  getTextColor(type: string): ResourceColor {
    const colors = {
      primary: '#92400E',
      accent: '#D97706',
      normal: '#000000',
      muted: '#6B7280'
    }
    return colors[type] || colors.normal
  }
  
  getInputBackground(): ResourceColor {
    return '#FFFBEB'
  }
  
  getPlaceholderColor(): ResourceColor {
    return '#F59E0B'
  }
  
  getButtonGradient(): ResourceColor {
    return '#F59E0B'
  }
  
  getResetButtonColor(): ResourceColor {
    return '#6B7280'
  }
  
  getHeaderBackground(): ResourceColor {
    return '#FEF3C7'
  }
  
  getRowBackground(): ResourceColor {
    return '#FFFBEB'
  }
}

// 类型定义
interface AppItem {
  app_id: string
  name: string
  icon_url: string
  developer_name: string
  kind_type_name: string
  kind_name: string
  tag_name: string
  average_rating: number
  total_star_rating_count: number
  download_count: number
  size_bytes: number
  metrics_created_at: string
  created_at: string
  listed_at: string
}

interface AppListParams {
  page: number
  page_size: number
  sort: string
  desc: boolean
  search_key?: string
  search_value?: string
  search_exact?: boolean
  exclude_huawei?: boolean
  exclude_atomic?: boolean
}