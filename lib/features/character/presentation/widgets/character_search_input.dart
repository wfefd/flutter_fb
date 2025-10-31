import 'package:flutter/material.dart';

class CharacterSearchInput extends StatelessWidget {
  final String selectedServer;
  final List<String> servers;
  final TextEditingController controller;
  final ValueChanged<String> onServerChanged;
  final VoidCallback onSearch;

  const CharacterSearchInput({
    super.key,
    required this.selectedServer,
    required this.servers,
    required this.controller,
    required this.onServerChanged,
    required this.onSearch,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 🔹 검색 박스 (서버선택 + 검색창)
            Container(
              width: MediaQuery.of(context).size.width * 0.9,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 12,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    "🎮 캐릭터 검색",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      // ✅ 서버 선택
                      Expanded(
                        flex: 4,
                        child: Container(
                          height: 48,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(12),
                            color: Colors.grey.shade50,
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: selectedServer,
                              borderRadius: BorderRadius.circular(12),
                              isExpanded: true,
                              icon: const Icon(Icons.arrow_drop_down),
                              items: servers
                                  .map(
                                    (s) => DropdownMenuItem(
                                      value: s,
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 10,
                                        ),
                                        child: Text(
                                          s,
                                          style: const TextStyle(fontSize: 14),
                                        ),
                                      ),
                                    ),
                                  )
                                  .toList(),
                              onChanged: (value) {
                                if (value != null) onServerChanged(value);
                              },
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),

                      // ✅ 검색 입력창
                      Expanded(
                        flex: 8,
                        child: Container(
                          height: 48,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(12),
                            color: Colors.grey.shade50,
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: controller,
                                  onSubmitted: (_) => onSearch(),
                                  decoration: const InputDecoration(
                                    hintText: '캐릭터 이름 입력',
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.symmetric(
                                      horizontal: 12,
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                height: 48,
                                width: 48,
                                decoration: const BoxDecoration(
                                  color: Color(0xFF7BC57B),
                                  borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(12),
                                    bottomRight: Radius.circular(12),
                                  ),
                                ),
                                child: IconButton(
                                  icon: const Icon(
                                    Icons.search,
                                    color: Colors.white,
                                  ),
                                  onPressed: onSearch,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 50),

            // 🔹 안내 문구
            const Text(
              '서버를 선택하고 캐릭터를 검색하세요 👇',
              style: TextStyle(color: Colors.grey, fontSize: 15),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
