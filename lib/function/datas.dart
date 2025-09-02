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
