import router from '@ohos.router';
import type { Contact } from '../common/types';


@Entry
@Component
export struct ContactPage {
  // 使用明确的 Contact 类型
  private contacts: Contact[] = [
    { name: 'shenjack (主要负责人)', email: '3695888@qq.com', iconColor: '#8b5cf6' },
    { name: 'tianxiu2b2t (v2站网页负责人)', email: 'administrator@ttb-network.top', iconColor: '#8b5cf6' },
  ];

  @Builder
  contactItem(contact: Contact) { // 使用接口类型而不是对象字面量
    Row() {
      Column() {}
      .width(24)
      .height(24)
      .backgroundColor(contact.iconColor) // 使用动态颜色
      .borderRadius(4)

      Column() {
        Text(contact.name)
          .fontWeight(FontWeight.Medium)
          .fontColor('#111827');

        Text(contact.email)
          .fontSize(14)
          .fontColor('#4b5563');
      }
      .margin({ left: 8 })
    }
    .margin({ top: 16 })
  }

  build() {
    Column() {
      // 返回按钮
      Column() {
        Button('返回仪表板')
          .width('100%')
          .backgroundColor(Color.Transparent)
          .borderRadius(6)
          .fontColor('#3b82f6')
          .onClick(() => {
            router.pushUrl({
              url: 'pages/Dashboard'
            });
          })
      }
      .margin({ bottom: 16 });

      // 页面标题
      Column() {
        Text('问题反馈 & 交流')
          .fontSize(24)
          .fontWeight(FontWeight.Bold)
          .fontColor('#6b21a8');

        Text('如有任何问题、建议或合作意向，请通过以下方式联系我们')
          .fontSize(14)
          .fontColor('#4b5563')
          .margin({ top: 4 });
      }
      .backgroundColor('#f5f3ff')
      .borderRadius(16)
      .padding(16)
      .margin({ bottom: 32 })

      // 联系方式卡片
      Column() {
        Text('联系方式')
          .fontSize(20)
          .fontWeight(FontWeight.Medium)
          .fontColor('#111827');

        ForEach(this.contacts, (item: Contact) => { // 为 ForEach 添加类型
          this.contactItem(item);
        });

        // QQ 群
        Row() {
          Column() {}
          .width(24)
          .height(24)
          .backgroundColor('#3b82f6')
          .borderRadius(4)

          Column() {
            Text('QQ群')
              .fontWeight(FontWeight.Medium)
              .fontColor('#111827');

            Text('757273833')
              .fontSize(14)
              .fontColor('#4b5563');
          }
          .margin({ left: 8 })
        }
        .margin({ top: 16 })
      }
      .backgroundColor(Color.White)
      .borderRadius(16)
      .padding(16)
      .margin({ bottom: 32 })
    }
    .width('100%')
    .height('100%')
    .padding(16)
    .backgroundColor('#f9fafb') // 添加背景色让页面更完整
  }
}