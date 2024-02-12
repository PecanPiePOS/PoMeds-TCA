# PoMeds

**PoMeds** 는 Pocket Medicine 의 줄임말로, 약을 복용함에 있어 약의 성분을 카메라로 찍어 편하게 기재하고, 공공 API [(e약은요)](https://www.data.go.kr/data/15075057/openapi.do) 를 사용하여 해당 약 성분을 검색하여 나의 비•정기적 복용을 체크할 수 있게 한다. 로컬 푸시 알림으로 사용자들에게 고지하며, 위젯을 사용하여 복용 여부를 빠르게 앱에 반영할 수 있습니다.

---

### 진행 사항

- ✅ 핵심 Feature 개발…
- ✅ TCA 에 익숙해지는 중…
- ✅ 나머지 복용 리스트 기능 구현 중
- 출시
- 테스트 코드 진행
- 다크 모드 구현
- 그 외의 이슈 Fix

---

### 배경

SwiftUI 와 TCA 를 연습하고자 만든 토이 프로젝트로, 출시까지 예정하고 있습니다. TCA 의 유지보수 또한 꾸준하게 블로깅이 될 예정입니다. 
클린 아키텍쳐를 염두하여 구조를 짰지만, TCA 를 적용함에 있어 최소한의 관심사 분리만 진행했습니다.

- **왜 TCA 인가?**
  
  SwiftUI 를 사용하면서 MVVM 패턴을 사용한다면, View 내부의 State 를 두번 사용하게 되는 경우가 다분합니다. 물론 할 수 있지만, 그리고 그렇다고 많이 불편한 것은 아니지만, @Binding 을 하면서 생기는 데이터 플로우의 이슈가 생길 수 있기 때문에 이런 양방향 데이터 플로우가 아닌 단방향의 플로우를 가진 TCA 프레임워크를 사용하여 단방향 패턴을 활요한 프로젝트를 진행하는 것이 목적이었습니다.
- 어떤 것이 좋은가?


    State 및 Action 에 관련된 사항을 Reducer 에 담아 단방향으로 처리하니 확실하게 View 와 비즈니스 로직을 편하게 분리할 수 있습니다.
    이 한줄로 큰 의미를 같습니다.
    
- 어떤 것이 나쁜가?
    
    네이티브 코드로 만든 패턴이 아니기 때문에, 아무래도 불안정 한 점이 많았으며, 특히 디버깅에서 문제가 많이 발생할 수 있습니다.
    더욱이, 끊임 없이 업데이트가 되고 있지만 실질적으로 그 사항을 TCA 를 처음 사용해보는 개발자가 제대로, 친절하게 확인할 수 있는 곳이 많이 없는 것 같습니다. (써드파티라면 당연한 것이지만.. [v1.7 Doc](https://pointfreeco.github.io/swift-composable-architecture/1.7.0/documentation/composablearchitecture/)) Slack 채널에 직접 들어가 TCA 를 개발하고 있는 개발자와 직접 소통을 해서 알아내야 합니다. (Slack 에서 TCA 를 만들고 있는 개발자와 직접 소통한다는 것은 좀 새롭고 재밌었습니다.)
    
---

### 보완해야할 점
- Binding 사용을 추가할 것
  (커스텀 Alert)
- ✅ Realm 의 Thread 문제를 해결하고 Dependency 추가 
- Camera 의 경우 ViewModel 이 아닌 Client 로 따로 Depedency 추가 
  (이 경우, Realm 과 같이 Thread 문제를 고민하면서 해야함)
- UseCase 와 Repository 를 Domian 에서 제대로 된 코드로 추가하기
- 위젯 및 로컬 노티피케이션 추가
- 기능 위주로 빠르게 구현하다보니 테스트를 전혀 진행하지 못함 -> 테스트 해야 함

---

### 블로그

트러블 슈팅 및 TCA 에 관련된 사항이 블로깅 될 블로그 주소입니다!

[PieZip 벨로그](https://velog.io/@hidra0321/posts)

---

### 가장 머리 아팠던 점

**Navigation 부분에서의 `@ObservableState` 가 추가되면서 바뀐 것들**

---

### 주요 기능

- 카메라 인식
    
    최대 8장까지 직접 찍어서 VisionKit 을 통해 Text 를 인식합니다.
    
- 복용 기록을 저장
- 공공 API 활용 *(개발 중)*
    
    공공 API 를 활용하여, 약의 성분에 대해 검색합니다.
    
- Local PushNotification 으로 시간에 따라 사용자에게 알려줌 *(개발 중)*
- 위젯으로 쉽게 복용 여부를 확인 가능 *(개발 중)*

---

### 사용 스택

- SwiftUI
- TCA
- Alamofire

- Combine
- RealmSwift
- Lottie

---

### 스크린 샷
<p align="left">
  <img width="200" alt="스크린샷1" src="https://github.com/PecanPiePOS/PoMeds/assets/89404664/3805df81-87f9-408e-947a-ccbacf6bc88d">
  <img width="200" alt="스크린샷1" src="https://github.com/PecanPiePOS/PoMeds/assets/89404664/79483bf7-3713-4669-b63b-dbc1380f96d6">
  <img width="200" alt="스크린샷1" src="https://github.com/PecanPiePOS/PoMeds/assets/89404664/1a6a3198-2c29-412c-8b21-d338df852ede">
  <img width="200" alt="스크린샷1" src="https://github.com/PecanPiePOS/PoMeds/assets/89404664/97318f32-3ffc-4fa4-ab68-e0aeddbc27ae">
  <img width="200" alt="스크린샷1" src="https://github.com/PecanPiePOS/PoMeds/assets/89404664/6497ee24-ac72-4efe-98b8-1668d0619e9b">
  <img width="200" alt="스크린샷1" src="https://github.com/PecanPiePOS/PoMeds/assets/89404664/4993adba-2eac-4990-b5f4-f5700837a2ca">
  <img width="200" alt="스크린샷1" src="https://github.com/PecanPiePOS/PoMeds/assets/89404664/12d95caa-6253-4546-b7b4-8ab9ec5bba85">
</p>


---

### 영상

  <img width="200" alt="스크린샷1" src="https://github.com/PecanPiePOS/PoMeds/assets/89404664/81075113-4bd3-4a4a-9109-5ff9b6a0195c">





