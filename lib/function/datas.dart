import 'package:flutter/material.dart';

List<String> backgroundsimg = [
  "assets/images/themes/spring.png",
  "assets/images/themes/summer.png",
  "assets/images/themes/fall.png",
  "assets/images/themes/winter.png",
];

class Backgroundnum {
  static int bn = 0;
}

List<String> bossimg = [
  "https://i.namu.wiki/i/Q8xQI_TCkMWfZ_Zynu9MzE_GL0zVo9h6i455zuTbqYTw3Au_5OJJLKEz1GkWt2jixRACdPvD9SdG9GAtquJHXg.webp", //검은마법사
  "https://i.namu.wiki/i/tEyLWr63aEloJAPhGE_exWYaiy75U9sl0FZTrZB6XAeC3dVOWM_5vJQ1azLFN7B4tyisP8sLdzibror6Wqb1PQ.webp", //발드릭스
  "https://i.namu.wiki/i/mKysj0adPdloUz38PsLoOhBvDnSsrS3JAMZS90MK4Nmn8Q2-dLxIn4xCijcHecs8Ax6GRPFtbmsVaKZgM5G5lg.webp", //림보
  "https://i.namu.wiki/i/T14htiH1QR3s114gWIe-oVYDHbsKitLiW_PkNMU3i1zkDO_SrFamzExKXgZJGn-ouL-8tODcKkSFCbIxeSYyUA.webp", //카링
  "https://i.namu.wiki/i/Z1fE3miveGkN8Sujgf7Dg7vLWUZpykzdRrXznXb7EeeSnq36O6jCfqcfVBP8MCZgWSc2iKnB-zroUlpkki8FYw.webp", //대적자
  "https://i.namu.wiki/i/r3gB7WNCxmxHP348t6yg_GTgNsGu3h3FdvwwKqgjPsglySlqiEeRPUIQaypzmD3nra-e--SYTcXivIX_y7mJNw.webp", //칼로스
  "https://i.namu.wiki/i/PzefptwttB1xJz2ItjPA4xO5xNtBm75E1IeIFRnsEUSche-aCv7V4tYKXofTITcNulQMPt-QOSJ0YoqdpJHVHw.webp", //세렌
  "https://i.namu.wiki/i/leCM_0rJMKaoCH37nBuYeo3to9H45MKo8zG394k_GjKPadK9eVec4DIXkQtIEPvsGV09A0ikYx36tCgdKhgIWQ.webp", //스우
  "https://i.namu.wiki/i/hJm3NSCP9_sPtG8Z6G1KCujwShncLChE19UY2BxRFBz1eUlmTQu-fjZE-fKIY1uCAaXqRlCRm5oRMexoR-Tvxw.webp", //진힐라
  "https://i.namu.wiki/i/OSfuiba0UEodmX0EH78ZuWFXJ3yX5vw-zaj0HeDCEaFff0vWNvijD3ZalJMux6cgP9jx413fFhlj9ZKE8TgQQA.webp", //듄켈
  "https://i.namu.wiki/i/Z_5RzKfdMePS0JCQTFAGw1A0W0wyxcYRH-YWQu86YWwSGgZSJr5yIowPHXyxTXbnHKd7xLnKkYRyU9R8sbHEWw.webp", //가엔슬
  "https://i.namu.wiki/i/DINCSt8yRDEB4D_o86FfQt66YiutZyjkCyydltHBuX6yc0JayzqISkU9Pv9BhY5AkxxLFdqdkqXFC-FrCTgrUg.webp", //더스크
  "https://i.namu.wiki/i/mKCkEEtbDrysH1MQJ4dN8yNkdqw7qrVUZtIqxDQvSXsHLwEyAl7YqJK7SHK05XvXwghkGwyqgcc8_rFzRCKOqg.webp", //윌
  "https://i.namu.wiki/i/qBXRxz93dm9xW5wF2Hrky7zSZRjjvKIEoP_uyt1xLDJJJqYUr4roaSqxEVBJmsR6LXLLqCIq9Kn0Mt4LSVvENA.webp", //루시드
  "https://i.namu.wiki/i/VzQAM_WIfsYkVTdKKxuHLhe_H1AtwnwBDQ4lYp5tp8U7IChuVXQ3YKyPbUHIrQavz2B6Qezjie5UnI1tIEFGnA.webp", //데미안
  "https://i.namu.wiki/i/No11uheIPScpXyAuXDMgl8rbMemQuNXOUVGJdZPqpW5A6Pmq79-G_mtBXpgjvkvDldv8aA1X7w-8-GScq0trUA.webp", //파풀라투스
  "https://i.namu.wiki/i/-yW4njIeN3H2JMmgwXV86lHfqSslu7JN8preDQZXVM6Gzz-03YnpGRdu9Ed1gmIdiZ0090eHCC-xqDeRxEc6PA.webp", //벨룸
  "https://i.namu.wiki/i/VGvCgTt3KQIqYiU1E8e0pRLeRmTJih-W2y-9hkJ2q6oYOeGqbt8-MwIJfBCEvPLndh65Bblq7OS0RlIzr8seuA.webp", //블러드퀸
  "https://i.namu.wiki/i/8RYnwG1KNqzCseklc3DOjLSYGCblGTqre6bmLLPmfO1RBpKjOR7yj2ZdYXPkrQeLp352xjZkfYo5tyATLbJL0w.webp", //피에르
  "https://i.namu.wiki/i/GlL2lzYKbUDJg5VQtZh3lcDA5hY6NPg9Vy6tb9hnI5sm3Vxq1sWsB-nMNw515D9uPgO_V3z4sZXcOOd8qP-IeQ.webp", //반반
  "https://i.namu.wiki/i/WbiEOVxzgemdtst_U3M-OeiA2csTOoyzufhIfHjcRmtThH6bd0PxMk5B9VFxtybCenrqxK3fIEyqc0JjDnzZVw.webp", //매그너스
  "https://i.namu.wiki/i/WlBhvyT6W1m6vy4EDQrpfayydYQNSXYhKxAGCjnyS5O-Bv2PNboI285tRTdbandVN-C59MD-JSSqqji86UQmXQ.webp", //시그너스
  "https://i.namu.wiki/i/I3IJr5djBukl-9Y1ilrzWhYOWE2C42a8vWOypmBISW9asT4ctfNae5iTNfyC39hWtYv8IHzH6EDTiZ7j2J3jIA.webp", //핑크빈
  "https://i.namu.wiki/i/BZ7NY6Kyghlo7ARRqiCvaGfzAqtlL5z5WLl2Ra2XDM3cjBue9z8ehWPnwrdW5BVCfUgvM9aR9_Pm5oiNmPhd8g.webp", //힐라
  "https://i.namu.wiki/i/qmb2HG2HHIEB9JHge94vzo0U1PScCl3oROIZm4UQHiSb9xyZnqIItV3Rz8m76zvA9fUwP3L8zym6SjoZMcY9Og.webp", //자쿰
  "https://i.namu.wiki/i/qcU87uoO6dYU8eKRGeBVXS8nC1VhF-9991x_VarZQz8-V-WsUYgbvKUnbppkB2yzBw652UXMYb2pPKuuRGvFiw.webp", //아카이럼
  "https://i.namu.wiki/i/Ueodj-SchRMNduY0WqGZGS698HcRlsfwennN4EQcXDKB1Dq6owFHhgCp_x06H_UjZySDwfCndnDmPfDDXrvfgg.webp", //반 레온
  "https://i.namu.wiki/i/y7uLf6cl_g4AYsF5v6-wACgFLJvnETSPzks5SoWhHYKWU7obIILrglT6M3IOsZ1uh-BrPb-rJYlB2YhqHRzoMg.webp", //혼테일
];

List<String> equipimg = [
  "https://i.namu.wiki/i/sYTUI2nRdQenS-Cgbn_psfLD7vDz0jQkMzNi6hP66pT_kS1Vh6NrKHbnSCIcRK7QhdpwrCOsQ1nILKHxwz5AEQ.webp", // 무기
  "https://i.namu.wiki/i/1nhs4sD4wI52AIvV74FizBESqH2oHA3YyiFsmGUL5eVEfgS5gLmMcvmip1sWqv_WQWwqJd7NAneEVtOOx4ddWw.png", // 보조무기
  "https://i.namu.wiki/i/ta1dYb7b4bgfGHoQ-huKMUUYBJEmfbFd8Lu0Hmnm-UG47EoGrASsZI4pBMJW2XhMf1tke8ZxqpgMAjL5ncWL2A.webp", // 엠블렘
  "https://i.namu.wiki/i/WqpULUkCvVuvJlJw8ke9rmMhDkUEqGnBqaWaXnTEqAIEunCgKARkmlmrfQImEffZ4eNYyK9xuxWaUb4Uz0QTUQ.png", // 모자
  "https://i.namu.wiki/i/GwAW-tf-GUB6iJEMiOB73URAbsbmydFrzcIjLWFD0kRSFwFL_hxqnnLasNZ2-QyIyMBICdYdzFN3rr3yamZZBQ.png", // 상의
  "https://i.namu.wiki/i/QdJkPGnuQIiy-EUvCZMsAvF1PWaEZMbsMRPdlpdBi0qp9cQPd9KHrEQMH-SwCEjYdUM_SLXkbAkHEBYckhmW3w.png", // 하의
  "https://i.namu.wiki/i/khYeQ6aKnXt-jlvD697SV7oAi0MDsfXRGrJP_F8wW4ICnP5WABheIOoOM6rCgWjc0mCKlDjnLfrmpP05QS_1Dg.png", // 신발
  "https://i.namu.wiki/i/kEIjzJOTkgoUSkoamT4IcUkRvcsCoUFxcH3qIFUEKjJ31Q_bOuRvzlMqESoMDSRCbhmXf7p0UUflauh0tCbf-A.png", // 장갑
  "https://i.namu.wiki/i/5i4AoSDZfg3gE6zsW2uU2JA2omT76AcsQNWUTksZk_ggLLljS3jz1VpGwqjGqKt6DrzTw2UV6BAbccWNopki1w.png", // 견장
  "https://i.namu.wiki/i/iimrd4dtG5Q_XUQDwtbQzdtojg--5GW2fY0jHmUrBbx4NO8RMRb-SD0mWMj4TPFAPrhoZasJOsV2oTVrhItLrg.png", // 망토
  "https://i.namu.wiki/i/RrOcSamWWkDXxywJaQjODI5hZm5Pt3AW0c4YnXNg4HOHj3KX5g8lKd5QXj6l9KseHLTm1AMYOdON0InpVatQcA.webp", // 귀고리
  "https://i.namu.wiki/i/h9P8xO-S_wbNocE9zyscF8aZ4jlegPrRtJMrrWWIDMH77nwMI3v2oAIXmXrjNSOJ2xuJzLahOKv4xQdH6tOV0Q.png", // 얼장
  "https://i.namu.wiki/i/zNxRsNo1U9dE3B1FYZCIgGNnj-I6GRG0W9YJc9kVl02w_TqrCbCqxcGeb870vudIiXJJgvLRrQpAHMKm3GXyog.webp", // 눈장
  "https://i.namu.wiki/i/KHJjAU9ddj1IrLFtkVXScpzkHipUWo6qU-hJmMBbCIIrQ5SWxvNudVyiC94JRizHKvdBf0p28Xfn8BmxaJRPTw.webp", // 반지
  "https://i.namu.wiki/i/SHdg5cgWjK1PBOAryc-pooUKft-a4D-ZYZhPt3csvH44yeYXS59JPbnRNSZVxvWXkmHlYmw4xwW9up5WEOWXZw.png", // 팬던트
  "https://i.namu.wiki/i/2zQde-EsaBNnNnyII-2y7GMxQxA5hpdMp5GxSjGW7aUqQ-kS85SlAUC7LBlyKcKtDMzKetXNu9HJI2i8GI-QzA.png", // 하트
  "https://i.namu.wiki/i/_bKK-YNDWKWyTy-4wwoc6pAq5wJqNZKhEJNslW3eHGJAlVOg7K5hCWD33qQmAnOehBvujo26Lj6BR8zbNnRrnw.png", // 벨트
];

List<String> equiptype = [
  "무기",
  "보조무기",
  "엠블렘",
  "모자",
  "상의",
  "하의",
  "신발",
  "장갑",
  "견장",
  "망토",
  "귀고리",
  "얼굴장식",
  "눈장식",
  "반지",
  "팬던트",
  "하트",
  "벨트",
];

final Map<String, Color> gradeColor = {
  '레어': Color(0xFF2EABC6),
  '에픽': Color(0xFF775AD9),
  '유니크': Color(0xFFf8a039),
  '레전드리': Color(0xFF7dbc00),
};
