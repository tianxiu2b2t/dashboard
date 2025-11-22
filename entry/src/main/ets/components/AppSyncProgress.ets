import { Component, Entry, Column, Row, Text, ProgressBar, Color, onMounted, onBeforeUnmount, ref } from "@kit.ArkUI";
import type { SyncProgress } from '../common/types';
import { formatCountTimeWithSpilt, formatCountTimeWithUnit, formatNumber } from '../common/utils';
import { BASE_API } from '../common/dynmaticAPI';

@Entry
@Component
export struct AppSyncProgress {
  private data = ref<SyncProgress>({
    is_syncing_all: false,
    progress: [0, 0],
    total_processed: 0,
    total_failed: 0,
    total_inserted: 0,
    total_skipped: 0,
    elapsed_time: { secs: 0, nanos: 0 },
    estimated_total_time: { secs: 0, nanos: 0 },
    next_sync_countdown: { secs: 0, nanos: 0 },
  });

  private nextSyncCountDown = ref<number>(0);
  private eventSource: EventSource | null = null;
  private updateNextSyncCountDownTask: any = null;

  @Builder
  build() {
    Column({ width: '100%', gap: 8 }) {
      Text('同步状态').fontSize(20).fontWeight('semibold')


      // 同步信息行
      Row({ justifyContent: 'space-between' }) {
        Text(this.data.value.is_syncing_all
          ? '正在同步中...'
          : '距离下次同步时间: ' + formatCountTimeWithUnit(this.nextSyncCountDown.value)
        ).fontWeight('semibold')
        Text(`${this.data.value.is_syncing_all ? '本次同步用时' : '上次同步用时'}: ${formatCountTimeWithUnit(this.data.value.elapsed_time.secs)}`).fontWeight('semibold')
      }

      // 总数统计
      Row({ justifyContent: 'space-between' }) {
        Column() {
          Text(`已插入应用数量: ${formatNumber(this.data.value.total_inserted)}`)
          Text(`已失败应用数量: ${formatNumber(this.data.value.total_failed)}`)
        }
        Column() {
          Text(`共处理应用数量: ${formatNumber(this.data.value.total_processed)}`)
          Text(`已跳过应用数量: ${formatNumber(this.data.value.total_skipped)}`)
        }
      }

      // 进度条
      Row({ justifyContent: 'space-between', visible: this.data.value.is_syncing_all }) {
        ProgressBar({
          progress: this.data.value.progress[1] > 0
            ? this.data.value.progress[0]/this.data.value.progress[1]
            : 0,
          height: 8,
          backgroundColor: Color('#e5e7eb'),
          progressColor: Color('#38bdf8'),
          borderRadius: 10,
          flexGrow: 1
        })
        Text(`${formatNumber(this.data.value.progress[0])}/${formatNumber(this.data.value.progress[1])} [${formatCountTimeWithSpilt(this.data.value.elapsed_time.secs)} < ${formatCountTimeWithSpilt(this.data.value.estimated_total_time.secs - this.data.value.elapsed_time.secs)}]`).padding({ left: 8 })
      }
    }


  }

  private startNextSyncCountDown() {
    if (this.updateNextSyncCountDownTask !== null) {
      clearInterval(this.updateNextSyncCountDownTask);
    }
    this.updateNextSyncCountDownTask = setInterval(() => {
      this.nextSyncCountDown.value -= 1;
    }, 1000);
  }

  onMounted() {
    this.eventSource = new EventSource(BASE_API + '/sync_status/stream');
    this.eventSource.addEventListener('sync_status', (event) => {
      const msg = JSON.parse(event.data) as SyncProgress;
      if (!msg.is_syncing_all) {
        this.nextSyncCountDown.value = msg.next_sync_countdown?.secs || 0;
        this.startNextSyncCountDown();
      }
      this.data.value = msg;
    });
  }

  onBeforeUnmount() {
    if (this.eventSource) {
      this.eventSource.close();
    }
    if (this.updateNextSyncCountDownTask !== null) {
      clearInterval(this.updateNextSyncCountDownTask);
    }
  }
}
