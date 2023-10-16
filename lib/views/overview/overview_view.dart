library overview;

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:easy_rich_text/easy_rich_text.dart';

part '../../controller/overview/overview_controller.dart';
part '../../controller/overview/taskitem_model.dart';
part './taskitem_view.dart';

class Overview extends StatelessWidget {
  const Overview({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // return const Text("xxx");
    if (context.mediaQuery.orientation == Orientation.portrait) {
      // 竖方向
      return <Widget>[
        _scheduler(),
        _running(),
        _pendings(),
        _waitings().constrained(maxHeight: 200),
        _logTitle(),
        _log()
      ].toColumn();
    } else {
      //横方向
      return <Widget>[
        // 左边
        <Widget>[
          _scheduler(),
          _running(),
          _pendings(),
          Expanded(child: _waitings()),
        ].toColumn().constrained(width: 300),
        // 右边
        <Widget>[_logTitle(), _log().expanded()]
            .toColumn(crossAxisAlignment: CrossAxisAlignment.start)
            .expanded()
      ].toRow();
    }
  }

  Widget _scheduler() {
    return <Widget>[
      Text("Scheduler",
          textAlign: TextAlign.left, style: Get.textTheme.titleMedium),
      IconButton(
        onPressed: () => {},
        icon: const Icon(Icons.power_settings_new_rounded),
        isSelected: false,
      ).paddingOnly(right: 0),
    ]
        .toRow(mainAxisAlignment: MainAxisAlignment.spaceBetween)
        .paddingOnly(left: 8, right: 8)
        .card(margin: const EdgeInsets.fromLTRB(10, 0, 10, 10));
  }

  Widget _running() {
    return GetX<OverviewController>(builder: (OverviewController controller) {
      return <Widget>[
        Text("Running",
            textAlign: TextAlign.left, style: Get.textTheme.titleMedium),
        const Divider(),
        TaskItemView.fromModel(controller.running.value)
      ]
          .toColumn(crossAxisAlignment: CrossAxisAlignment.start)
          .paddingAll(8)
          .card(margin: const EdgeInsets.fromLTRB(10, 0, 10, 10));
    });
  }

  Widget _pendings() {
    return GetX<OverviewController>(builder: (OverviewController controller) {
      return <Widget>[
        Text("Pandings",
            textAlign: TextAlign.left, style: Get.textTheme.titleMedium),
        const Divider(),
        SizedBox(
            height: 160,
            child: ListView.builder(
                itemBuilder: (context, index) =>
                    TaskItemView.fromModel(controller.pendings[index]),
                itemCount: controller.pendings.length))
      ]
          .toColumn(crossAxisAlignment: CrossAxisAlignment.start)
          .paddingAll(8)
          .card(margin: const EdgeInsets.fromLTRB(10, 0, 10, 10));
    });
  }

  Widget _waitings() {
    return GetX<OverviewController>(builder: (OverviewController controller) {
      return <Widget>[
        Text("Waitings",
            textAlign: TextAlign.left, style: Get.textTheme.titleMedium),
        const Divider(),
        Expanded(
            child: ListView.builder(
                itemBuilder: (context, index) =>
                    TaskItemView.fromModel(controller.waitings[index]),
                itemCount: controller.waitings.length))
      ]
          .toColumn(
            crossAxisAlignment: CrossAxisAlignment.start,
          )
          .paddingAll(8)
          .card(margin: const EdgeInsets.fromLTRB(10, 0, 10, 10));
    });
  }

  Widget _logTitle() {
    return <Widget>[
      Text("Log", textAlign: TextAlign.left, style: Get.textTheme.titleMedium),
      // MaterialButton(
      //   onPressed: () => {},
      //   child: const Text("Auto Scroll ON"),
      // ),
    ]
        .toRow(mainAxisAlignment: MainAxisAlignment.spaceBetween)
        .paddingAll(8)
        .card(margin: const EdgeInsets.fromLTRB(0, 0, 10, 10));
  }

  Widget _log() {
    return GetX<OverviewController>(builder: (OverviewController controller) {
      return EasyRichText(
        controller.log.value,
        maxLines: 3,
        overflow: TextOverflow.ellipsis,
        selectable: true,
        defaultStyle: Get.textTheme.titleSmall,
        patternList: [
          // INFO
          EasyRichTextPattern(
            targetString: 'INFO',
            style: const TextStyle(color: Color.fromARGB(255, 55, 109, 136)),
          ),
          // WARNING
          EasyRichTextPattern(
            targetString: 'WARNING',
            style: const TextStyle(color: Colors.yellow),
          ),
          // ERROR
          EasyRichTextPattern(
            targetString: 'ERROR',
            style: const TextStyle(color: Colors.red),
          ),
          // CRITICAL
          EasyRichTextPattern(
            targetString: 'CRITICAL',
            style: const TextStyle(color: Colors.red),
          ),
          // 时间的
          EasyRichTextPattern(
            targetString: r'(\d{2}:\d{2}:\d{2}\.\d{3})',
            style: const TextStyle(color: Colors.cyan),
          ),
          // 粗体
          EasyRichTextPattern(
            targetString: r'[\{\[\(\)\]\}]',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          // True
          EasyRichTextPattern(
              targetString: 'True',
              style: const TextStyle(color: Colors.lightGreen)),
          // False
          EasyRichTextPattern(
              targetString: 'False', style: const TextStyle(color: Colors.red)),
          // None
          EasyRichTextPattern(
              targetString: 'None',
              style: const TextStyle(color: Colors.purple)),
          // 路径Path
          // EasyRichTextPattern(
          //     targetString: r'([A-Za-z]\:)|.)?\B([\/\\][\w\.\-\_\+]+)*[\/\\]',
          //     style: const TextStyle(
          //         color: Colors.purple, fontStyle: FontStyle.italic)),
          // 分割线
          EasyRichTextPattern(
            targetString: r'(══*══)|(──*──)',
            style: const TextStyle(color: Colors.lightGreen),
          )
        ],
      )
          .paddingAll(10)
          .constrained(width: double.infinity, height: double.infinity)
          .card(margin: const EdgeInsets.fromLTRB(0, 0, 10, 10));
    });
  }
}