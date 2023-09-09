part of nav_menu;

class NavMenuController extends GetxController {
  final treeData = Rx<List<TreeNodeData>>([]);
  final serverData = [
    {
      "checked": true,
      "children": [
        {
          "checked": true,
          "show": false,
          "children": [],
          "id": 11,
          "pid": 1,
          "text": "Overview",
        },
      ],
      "id": 1,
      "pid": 0,
      "show": false,
      "text": "Overview",
    },
    {
      "checked": true,
      "show": false,
      "children": [],
      "id": 2,
      "pid": 0,
      "text": "Parent title 2",
    },
    {
      "checked": true,
      "children": [],
      "id": 3,
      "pid": 0,
      "show": true,
      "text": "Parent title 3",
    },
  ];

  @override
  void onInit() {
    treeData.value = List.generate(
      serverData.length,
      (index) => mapServerDataToTreeData(serverData[index]),
    );
    super.onInit();
  }

  TreeNodeData mapServerDataToTreeData(Map data) {
    return TreeNodeData(
      extra: data,
      title: data['text'],
      expanded: data['show'],
      checked: data['checked'],
      children:
          List.from(data['children'].map((x) => mapServerDataToTreeData(x))),
    );
  }
}