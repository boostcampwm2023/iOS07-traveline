# 🌎 traveline
> 여행 일정을 타임라인으로 **기록**하고 **공유**하는 **여행 SNS 서비스**입니다.  
나만의 여행을 공유하고 다양한 여행들을 만나보아요 :)

<br>

![기능 소개 페이지](https://github.com/boostcampwm2023/iOS07-traveline/assets/51712973/f39271ee-26a8-41d2-b18d-32d44f79fd43)

</br>

#### 나랑 비슷한 취향과 환경을 가진 다양한 여행들을 만나고 나만의 여행 계획을 짜보아요 !
- 지역, 기간, 테마 등 총 8 가지의 필터를 통해 내가 원하는 여행을 찾을 수 있어요.
- 키워드 검색을 통해 원하는 여행을 바로 탐색할 수 있어요.
- 매 날짜마다 시간 순으로 기록된 여행들을 통해 보다 쉽게 일정을 확인할 수 있어요.
- 지도로 보기 기능을 통해 어떤 장소에 머물렀는지 지도로 한눈에 볼 수 있어요.

<br>

#### Traveline 팀 소개
|S009 김영인|S013 김태현|S041 홍기웅|J048 박경미|J170 황정민|
|:-:|:-:|:-:|:-:|:-:|
|<img src="https://avatars.githubusercontent.com/u/74968390?v=4" width=150>|<img src="https://user-images.githubusercontent.com/51712973/280571628-e1126b86-4941-49fc-852b-9ce16f3e0c4e.jpg" width=150>|<img src="https://avatars.githubusercontent.com/u/91725382?s=400&u=29b8023a56a09685aaab53d4eb0dd556254cd902&v=4" width=150>|<img src="https://github.com/boostcampwm2023/iOS07-Trapture/assets/74968390/76bfffde-8ebc-445d-8f3a-7c21288ae386" width=150>|<img src="https://github.com/boostcampwm2023/iOS07-Trapture/assets/74968390/3f5281e2-d233-49d2-b836-be2a56f93096" width=150>|
|[@0inn](https://github.com/0inn)|[@kth1210](https://github.com/kth1210)|[@otoolz](https://github.com/otoolz)|[@kmi0817](https://github.com/kmi0817)|[@yaongmeow](https://github.com/yaongmeow)|
|iOS|iOS|iOS|BE|BE|

<br>

## 프로젝트 구조
|iOS|![프로젝트 구조도](https://github.com/boostcampwm2023/iOS07-traveline/assets/74968390/d4477585-eac2-481c-baf7-80d394eacaae)|
|:-:|:-:|
|BE|![image](https://github.com/boostcampwm2023/iOS07-traveline/assets/62174395/79d2c0a6-4e8c-4547-acd6-a2b4ea95ce68)|

<br>

## iOS 기술 스택

#### MVVM + CleanArchitecture
- 현재 서비스 기획 간 복잡한 아키텍처의 필요성을 느끼지 못했고, 작업 간 로직 분리의 용이함을 위해 선택했습니다.
- 또한 여러 명이 동시에 개발해야하기 때문에 CleanArchitecture를 활용해 역할 분리를 확실히 해두어 코드의 통일성을 유지했습니다.
- Repository 패턴을 통해 Data Source를 캡슐화할 수 있었고, RepositoryMock을 이용해 서버 개발 상황에 관계없이 개발을 진행할 수 있었습니다.
#### Combine
- Third-party인 RxSwift에 비해 시간, 공간적 성능이 우수하기 때문에 First-party인 Combine을 선택했습니다.
- 데이터 스트리밍을 조작하고 구독하는 것에 최적화된 Combine을 UI Binding에 활용했습니다.
#### Swift Concurrency
- Concurrency를 활용해 단발성 비동기 응답인 네트워크 로직을 보다 직관적으로 처리해주기 위해 선택했습니다.
- Repository - Network의 흐름을 간결하게 작성할 수 있었습니다.
#### MapKit
- 지도 위에 마커를 표시하고 정보를 보여주기 위해 사용했습니다.
- 위치 좌표 정보만 서버에서 받아오면 되기 때문에 다른 Third-party 지도를 사용할 필요가 없다고 생각해 애플 프레임워크인 MapKit을 선택했습니다.
#### Keychain
- 로그인 이후 토큰 등 민감한 사용자 정보를 안전하게 저장하고 관리하기 위해 사용했습니다.

<br>

## BE 기술 스택

#### NestJS + TypeORM

- 원활한 협업과 코드 리뷰를 위해 자율성이 높은 Express는 적절하지 않다고 생각했습니다. 따라서 아키텍처가 갖춰지고, TypeScript가 기반인 NestJS를 선택했습니다.
- 일인자 TypeORM과 요즘 핫한 Prisma. TypeORM 사용자에게 Prisma가 인기 있는 이유를 이해하려면 TypeORM을 알아야 합니다. 따라서 저희는 먼저 TypeORM을 경험하고자 했습니다.

#### RDB

- traveline 앱은 하나의 게시글에 여러 타임라인 글이 연결됩니다. 또한 각 게시글에는 좋아요와 신고 정보가 존재합니다.
- 테이블 간 join 연산이 많이 발생할 것이므로 NoSQL보단 RDB가 적절하다고 판단했습니다.

#### GitHub Actions + Docker

- 원래 수동 배포를 시도했지만, node 버전 이슈와 systemd service 등록 과정에 어려움을 겪었습니다. 따라서 로컬 작업 환경을 그대로 컨테이너를 구성할 수 있고, 이식성이 뛰어나며 지속적인 배포에도 유용한 Docker를 사용했습니다.
- Swagger API를 서둘러 iOS 측에 공유하기 위해 러닝 커브가 낮고, 신속한 세팅이 가능한 GitHub Actions로 배포를 진행했습니다.

#### Let’s Encrypt + Nginx

- 애플 정책상 ipa는 https에서만 배포할 수 있습니다. 이에, 90일마다 SSL 인증서를 갱신해야 하지만 무료로 발급받을 수 있는 Let’s Encrypt를 사용했습니다.
- Nest 서버에서 직접 SSL 인증서를 관리하려면 코드 수정이 불가피합니다. 반면 웹 서버를 Reverse Proxy로 사용하면 간단하게 SSL 구성을 완료할 수 있습니다. 또한 애플리케이션 코드에 SSL 관련 횡단 관심사 코드가 존재하지 않아, 더욱 핵심에 집중할 수 있습니다.

#### AWS SES (Simple Email Service)

- traveline은 새로운 IP로 로그인 시 본인 확인 메일을 전송하는 서비스를 제공합니다.
- Nest 내장 모듈인 `nodemailer`는 보안상 취약점이 발견되어 실서비스에서는 사용되지 않습니다. NCP의 `Cloud Outbound Mailer`는 어뷰징 문제로 인해 현재 *(2023.12)* 서비스 신청이 막혀 있습니다. 이에, AWS SES를 사용했습니다.

<br>

## 🔥 우리의 도전들
### iOS
#### - [단방향 플로우 ViewModel 구현기](https://github.com/boostcampwm2023/iOS07-traveline/wiki/%5BiOS%5D-%EB%8B%A8%EB%B0%A9%ED%96%A5-%ED%94%8C%EB%A1%9C%EC%9A%B0-ViewModel-%EA%B5%AC%ED%98%84%EA%B8%B0)
#### - [Concurrency와 Combine의 공존](https://github.com/boostcampwm2023/iOS07-traveline/wiki/%5BiOS%5D-Concurrency%EC%99%80-Combine%EC%9D%98-%EA%B3%B5%EC%A1%B4)
#### - [traveline의 이미지 관리하기](https://github.com/boostcampwm2023/iOS07-traveline/wiki/%5BiOS%5D-traveline%EC%9D%98-%EC%9D%B4%EB%AF%B8%EC%A7%80-%EA%B4%80%EB%A6%AC%ED%95%98%EA%B8%B0)
#### - [traveline 디자인 시스템 구축기](https://github.com/boostcampwm2023/iOS07-traveline/wiki/%5BiOS%5D-traveline-%EB%94%94%EC%9E%90%EC%9D%B8-%EC%8B%9C%EC%8A%A4%ED%85%9C-%EA%B5%AC%EC%B6%95%EA%B8%B0)
#### - [KeychainWrapper로 사용자 정보 관리하기](https://github.com/boostcampwm2023/iOS07-traveline/wiki/%5BiOS%5D-KeychainWrapper%EB%A1%9C-%EC%82%AC%EC%9A%A9%EC%9E%90-%EC%A0%95%EB%B3%B4-%EA%B4%80%EB%A6%AC%ED%95%98%EA%B8%B0)
#### - [권한 설정 없이 사진의 시간 메타데이터 가져오기](https://github.com/boostcampwm2023/iOS07-traveline/wiki/%5BiOS%5D-%EA%B6%8C%ED%95%9C-%EC%84%A4%EC%A0%95-%EC%97%86%EC%9D%B4-%EC%82%AC%EC%A7%84%EC%9D%98-%EC%8B%9C%EA%B0%84-%EB%A9%94%ED%83%80%EB%8D%B0%EC%9D%B4%ED%84%B0-%EA%B0%80%EC%A0%B8%EC%98%A4%EA%B8%B0)
#### - [사이드 바 사용성 개선기](https://github.com/boostcampwm2023/iOS07-traveline/wiki/%5BiOS%5D-%EC%82%AC%EC%9D%B4%EB%93%9C-%EB%B0%94%EC%9D%98-%EC%82%AC%EC%9A%A9%EC%84%B1-%EA%B0%9C%EC%84%A0%EA%B8%B0)
#### - [MapKit으로 타임라인 보여주기](https://github.com/boostcampwm2023/iOS07-traveline/wiki/%5BiOS%5D-MapKit%EC%9C%BC%EB%A1%9C-%ED%83%80%EC%9E%84%EB%9D%BC%EC%9D%B8-%EB%B3%B4%EC%97%AC%EC%A3%BC%EA%B8%B0)
#### - [작업을 서로 바꿔서 해보자!](https://github.com/boostcampwm2023/iOS07-traveline/wiki/%5BiOS%5D-%EC%9E%91%EC%97%85%EC%9D%84-%EC%84%9C%EB%A1%9C-%EB%B0%94%EA%BF%94%EC%84%9C-%ED%95%B4%EB%B3%B4%EC%9E%90!)

### BE
#### - [생애 첫 CI CD 도전기](https://github.com/boostcampwm2023/iOS07-traveline/wiki/%5BBE%5D-%EC%83%9D%EC%95%A0-%EC%B2%AB-CI-CD-%EB%8F%84%EC%A0%84%EA%B8%B0)
#### - [@nestjs/swagger로 이미지 업로드 form을 어떻게 만들지?](https://github.com/boostcampwm2023/iOS07-traveline/wiki/%5BBE%5D-@nestjs-swagger%EB%A1%9C-%EC%9D%B4%EB%AF%B8%EC%A7%80-%EC%97%85%EB%A1%9C%EB%93%9C-form%EC%9D%84-%EC%96%B4%EB%96%BB%EA%B2%8C-%EB%A7%8C%EB%93%A4%EC%A7%80%3F)
#### - [클라이언트에서만 발생하는 413 Content Too Large 에러?](https://github.com/boostcampwm2023/iOS07-traveline/wiki/%5BBE%5D-%ED%81%B4%EB%9D%BC%EC%9D%B4%EC%96%B8%ED%8A%B8%EC%97%90%EC%84%9C%EB%A7%8C-%EB%B0%9C%EC%83%9D%ED%95%98%EB%8A%94-413-Content-Too-Large-%EC%97%90%EB%9F%AC%3F)
#### - [트랜잭션은 쿼리문만 다루지, 스토리지는 신경 쓰지 않아요](https://github.com/boostcampwm2023/iOS07-traveline/wiki/%5BBE%5D-%ED%8A%B8%EB%9E%9C%EC%9E%AD%EC%85%98%EC%9D%80-%EC%BF%BC%EB%A6%AC%EB%AC%B8%EB%A7%8C-%EB%8B%A4%EB%A3%A8%EC%A7%80,-%EC%8A%A4%ED%86%A0%EB%A6%AC%EC%A7%80%EB%8A%94-%EC%8B%A0%EA%B2%BD-%EC%93%B0%EC%A7%80-%EC%95%8A%EC%95%84%EC%9A%94)
#### - [애플 로그인 구현 과정](https://github.com/boostcampwm2023/iOS07-traveline/wiki/%5BBE%5D-애플-로그인-구현-과정)
#### - [이메일 서비스 적용 과정](https://github.com/boostcampwm2023/iOS07-traveline/wiki/%5BBE%5D-이메일-서비스-적용-과정)
#### - [로그인 로그아웃 처리](https://github.com/boostcampwm2023/iOS07-traveline/wiki/%5BBE%5D-로그인-로그아웃-처리)

<br>

|📚 문서|[Wiki](https://github.com/boostcampwm2023/iOS07-traveline/wiki)|[팀 노션](https://spiky-rat-16e.notion.site/6b9791faac7e4b9d9a31d225ce8cd157?pvs=4)|[그라운드 룰](https://github.com/boostcampwm2023/iOS07-traveline/wiki/%ED%8C%80-%EA%B7%B8%EB%9D%BC%EC%9A%B4%EB%93%9C-%EB%A3%B0)|[컨벤션](https://github.com/boostcampwm2023/iOS07-traveline/wiki/GitHub-%EC%BB%A8%EB%B2%A4%EC%85%98)|[회의록](https://www.notion.so/bd676cad762c4cffa7b081c65939b0c5?v=76fe42efa9f1497b98764bf47ff47598&pvs=4)|[기획/디자인](https://www.figma.com/file/RrmfjBTxuLMAYRiXrbKQSW/traveline?type=design&node-id=2%3A2&mode=design&t=AD0PpylqwYoldl8g-1)|
|:-:|:-:|:-:|:-:|:-:|:-:|:--:|
