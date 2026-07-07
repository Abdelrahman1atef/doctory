# Attachments API — Endpoint Flow & Mobile Integration Guide

## Overview

The Attachments system handles file upload/download/update for various media types (images, videos, audio, documents). Files are stored on the server's `wwwroot` directory under paths configured in `appsettings.json` (`UploadPaths` section). All endpoints are protected by `[RoleAuthorize]` and return responses wrapped in `ApiResponse<T>`.

Base URL: `/api/v1/attachments`

---

## Place (Folder) Mapping

The `Place` integer tells the system **which folder** to store/retrieve the file from. This maps to `UploadPaths` configuration values.

| Place | Key               | Typical Use              |
|-------|-------------------|--------------------------|
| 0     | DefaultUserImage  | Default user avatar      |
| 1     | UserImages        | User profile images      |
| 2     | PostImages        | Post images              |
| 3     | PostVideos        | Post videos              |
| 4     | PostDocuments     | Post documents           |
| 5     | ClinicImages      | Clinic photos            |
| 6     | ClinicDocuments   | Clinic documents         |
| 7     | DoctorImages      | Doctor profile photos    |
| 8     | DoctorDocuments   | Doctor documents         |
| 9     | MessageImages     | Chat message images      |
| 10    | MessageVideos     | Chat message videos      |
| 11    | MessageDocuments  | Chat message documents   |
| 12    | MessageAudio      | Chat voice messages      |

---

## MediaType Enum

| Value | Name  |
|-------|-------|
| 0     | Image |
| 1     | Video |
| 2     | Audio |
| 3     | File  |

This determines **validator & storage logic** (allowed extensions, service used).

---

## Backend Endpoints

### 1. Upload Single File

`POST /api/v1/attachments/upload`

**Used by:** Chat feature

**Content-Type:** `multipart/form-data`

| Field      | Type      | Description                           |
|------------|-----------|---------------------------------------|
| `File`     | `IFormFile` | The file to upload                   |
| `Place`    | `int`     | Target folder (0–12, see table above) |
| `FileType` | `int`     | `MediaType` enum value (0–3)          |

**Flow:**
```
Controller → UploadFileCommand → Validator (file not empty, Place 0–12, FileType valid enum)
                                 → Handler → Router to correct validator by MediaType:
                                    - Image  → ImageValidator.UploadImage  (allowed: .jpg,.jpeg,.png,.gif,.bmp,.webp)
                                    - Video  → VideoValidator.UploadVideo  (allowed: .mp4,.avi,.mkv,.mov,.wmv)
                                    - Audio  → AudioValidator.UploadAudio  (allowed: .mp3,.wav,.ogg,.m4a,.aac)
                                    - File   → FileValidator.UploadFile    (allowed: .pdf,.doc,.docx,.xls,.xlsx,.txt,.zip,.rar)
                                  → BaseFileService.UploadFileAsync → saves to wwwroot/{folderPath}/{guid}.ext
                                  → Returns "{Place}_{guid}.ext" string
```

**Example Response (200):**
```json
{
  "success": true,
  "data": null,
  "message": "5_3a1f2b4c-...jpg",
  "statusCode": 200
}
```

**Example Response (400 — validation error):**
```json
{
  "success": false,
  "errors": { "File": ["File is required"] },
  "data": null,
  "statusCode": 400
}
```

---

### 2. Update (Replace) File

`PATCH /api/v1/attachments/update/{name}`

**Content-Type:** `multipart/form-data`

| Field      | Type      | Description                           |
|------------|-----------|---------------------------------------|
| `File`     | `IFormFile` | The new file                        |
| `Place`    | `int`     | Target folder (0–12)                  |
| `FileType` | `int`     | `MediaType` enum value (0–3)          |

The `{name}` path parameter is the **old file name** (e.g. `"5_old-guid.jpg"`).

**Flow:**
```
Controller → extracts {name} → sets command.OldFileName = name
          → UpdateFileCommand → Validator (same as upload)
                               → Handler → Deletes old file via correct validator's Delete* method
                                          → Uploads new file (same as upload flow)
                                          → Returns "{Place}_{new-guid}.ext"
```

**Note:** The old file name is parsed to extract the actual GUID (everything after the first `_`).

---

### 3. Upload Multiple Attachments

`POST /api/v1/attachments/upload-multiple-attachments`

**Content-Type:** `multipart/form-data`

| Field           | Type          | Description                    |
|-----------------|---------------|--------------------------------|
| `Images`        | `List<IFormFile>` | Multiple image files        |
| `ImagesPlace`   | `int`         | Place for images (0–12)        |
| `Videos`        | `List<IFormFile>` | Multiple video files        |
| `VideosPlace`   | `int`         | Place for videos (0–12)        |
| `Audios`        | `List<IFormFile>` | Multiple audio files        |
| `AudiosPlace`   | `int`         | Place for audios (0–12)        |
| `Documents`     | `List<IFormFile>` | Multiple document files    |
| `DocumentsPlace`| `int`         | Place for documents (0–12)     |

**Rule:** At least one file group must be non-empty.

**Flow:**
```
Controller → UploadMultipleAttachmentsCommand → Validator (at least one group has files, all Places 0–12)
                                              → Handler → For each non-null group:
                                                           Images   → ImageValidator.UploadMultipleImage
                                                           Videos   → VideoValidator.UploadMultipleVideo
                                                           Audios   → AudioValidator.UploadAudio (one by one)
                                                           Documents→ FileValidator.UploadMultipleFile
                                              → Returns List<string> of all resulting filenames
```

---

### 4. Download File

`POST /api/v1/attachments/download`

**Content-Type:** `multipart/form-data`

| Field      | Type     | Description                    |
|------------|----------|--------------------------------|
| `Place`    | `int`    | Folder where file is stored    |
| `FileName` | `string` | File name (e.g. `"5_guid.jpg"`)|

**Flow:**
```
Controller → DownloadFileCommand → Validator (FileName not empty, Place 0–12)
                                  → Handler → FileValidator.DownloadFile → BaseFileService.DownloadFileAsync
                                             → Checks if wwwroot/{folderPath}/{fileName} exists
                                             → Detects MIME type via FileExtensionContentTypeProvider
                                             → Returns FileResponseDto
```

**Example Response (200):**
```json
{
  "success": true,
  "data": {
    "filePath": "C:\\...\\wwwroot\\uploads\\images\\guid.jpg",
    "fileName": "guid.jpg",
    "contentType": "image/jpeg",
    "success": true,
    "errorMessage": null
  },
  "statusCode": 200
}
```

**Example Response (400 — file not found):**
```json
{
  "success": true,
  "data": {
    "filePath": "",
    "fileName": "",
    "contentType": "application/octet-stream",
    "success": false,
    "errorMessage": "File not found"
  },
  "statusCode": 200
}
```

---

## Flutter Mobile App Integration

### Endpoint Mapping (Flutter Data Source → Backend)

Both create post and chat features use the **generic** upload endpoint (`attachments/upload`) with a `FileType` field to distinguish media type. Batch uploads use `attachments/upload-multiple-attachments` with type-specific field names. Auth endpoints use a different prefix.

| Flutter Data Source | Flutter Method | Backend Endpoint | Place | FileType | Used For |
|---|---|---|---|---|---|
| `CreatePostRemoteDataSource` | `uploadImage()` | `attachments/upload` | 2 | 0 (Image) | Single post image |
| `CreatePostRemoteDataSource` | `uploadVideo()` | `attachments/upload` | 3 | 1 (Video) | Single post video |
| `CreatePostRemoteDataSource` | `uploadAudio()` | `attachments/upload` | 4 | 2 (Audio) | Single post audio |
| `CreatePostRemoteDataSource` | `uploadFile()` | `attachments/upload` | 4 | 3 (File) | Single post document |
| `CreatePostRemoteDataSource` | `uploadMultipleImages()` | `attachments/upload-multiple-attachments` | 2 | — | Batch post images (`Images`/`ImagesPlace`) |
| `CreatePostRemoteDataSource` | `uploadMultipleVideos()` | `attachments/upload-multiple-attachments` | 3 | — | Batch post videos (`Videos`/`VideosPlace`) |
| `ChatRemoteDataSource` | `uploadChatMedia()` | `attachments/upload` | 9–12 | 0–3 | Chat message media |
| `AuthRemoteDataSource` | `signup()` | `/Auth/signup` | — | — | Signup with cert/syndicate images |
| `AuthRemoteDataSource` | `updateProfile()` | `/Auth/profile/update` | — | — | Profile update (JSON, no file) |

**Note:** Backend paths without a leading `/` are relative to the configured base URL. Auth endpoints use absolute paths (`/Auth/...`).

### Upload Infrastructure

All uploads flow through a consistent pipeline:

```
Feature Section
  → Feature Cubit
    → Feature Repository
      → Feature Remote Data Source
        → ApiConsumer.uploadFile<T>()    [lib/core/network/interfaces/api_consumer.dart]
          → DioConsumer.uploadFile<T>()  [lib/core/network/impl/dio_consumer.dart]
            → FormData.fromMap(data)     [Dio wraps Map in multipart/form-data]
            → Dio.post(path, data: formData, onSendProgress: ...)
            → ApiResult<T> via fold()
```

#### ApiConsumer Interface

The abstract interface defines 7 HTTP methods including:

| Method | Purpose |
|---|---|
| `get<T>` | Standard GET |
| `post<T>` | POST (supports `isFormData: true` for multipart) |
| `put<T>` | PUT |
| `patch<T>` | PATCH |
| `delete<T>` | DELETE |
| `uploadFile<T>` | **File upload** — sends `FormData` via POST |
| `downloadFile` | File download — saves to local path via Dio download |

All methods return `ApiResult<T>` — never throw.

#### DioConsumer Upload Flow

1. **Connectivity check** → returns `NoInternetFailure` if offline
2. **Auth header** → auto-injects `Authorization: Bearer {token}` from `UserSession`
3. **Content-Type removal** → removes explicit `Content-Type` so Dio auto-sets `multipart/form-data` with boundary
4. **FormData wrapping** → `data` map passed to `FormData.fromMap()` — `MultipartFile` entries handled natively
5. **Progress tracking** → `onSendProgress` callback supported but **not currently wired in chat cubit**
6. **Parser** → optional `T Function(Map<String, dynamic>)` transforms raw JSON to typed model
7. **Error handling** → `DioException` routed through `ErrorHandler.handleDioException()` to typed `Failure`

### Core Flutter Upload Services

| Service | Location | Purpose |
|---|---|---|
| `MyMedia` | `lib/core/services/media/my_media.dart` | File/image picking (gallery, camera, file system) with permission handling |
| `MediaCompressionService` | `lib/core/services/media/media_compression_service.dart` | Image compression (flutter_image_compress, 85→10 quality) & video compression (video_compress, MediumQuality). Image limit: 10 MB, Video limit: 10 GB |
| `PostUploadService` | `lib/core/services/post_upload_service.dart` | Background upload queue with retry/dismiss. Manages `PostUploadTask` stream for UI binding |
| `FileOpenerService` | `lib/core/services/media/file_opener_service.dart` | Download + open files via `open_filex` |
| `AlertOfMedia` | `lib/core/services/media/alert_of_media.dart` | Reusable camera/gallery picker dialog |

---

### Feature Integration Flows

#### 1. Create Post

```
Section → CreatePostCubit.createPost(content, media)
  → CreatePostRepo.createPostWithMedia()
    → For each image:   remoteDataSource.uploadImage(file)     → POST attachments/upload (FileType=0)
    → For each video:   remoteDataSource.uploadVideo(file)     → POST attachments/upload (FileType=1)
    → For each audio:   remoteDataSource.uploadAudio(file)     → POST attachments/upload (FileType=2)
    → For each file:    remoteDataSource.uploadFile(file)      → POST attachments/upload (FileType=3)
    → remoteDataSource.createPost(content, uploadedUrls)       → POST posts/create
  → ApiResult fold: emit success/error
```

**Batch upload** (multiple files of same type):
- `uploadMultipleImages(files)` → `POST attachments/upload-multiple-attachments` (field: `Images`, `ImagesPlace`)
- `uploadMultipleVideos(files)` → `POST attachments/upload-multiple-attachments` (field: `Videos`, `VideosPlace`)

**Response format** — single upload endpoints return the filename in `json['message']` (`data` is `null`). Batch upload endpoints return the filename list in `json['data']`.

**Key files:**
- `lib/features/create_post/data/data_source/create_post_remote_data_source.dart`
- `lib/features/create_post/data/repo/create_post_repo.dart`
- `lib/features/create_post/cubit/create_post_cubit.dart`

#### 2. Chat

```
Section → ChatRoomCubit.pickMedia() / pickFile()
  → ChatRoomCubit._uploadAttachment()
    → ChatRepo.uploadChatMedia(attachment)
      → ChatRemoteDataSource.uploadChatMedia(file, place, fileType)
        → apiConsumer.uploadFile(path: 'attachments/upload', data: {File, Place, FileType})
    → stores uploadedFileName + uploadedMediaType in state
  → ChatRoomCubit.sendMessage()
    → ChatRepo.sendMessage(conversationId, content, mediaPayload)
      → ChatRemoteDataSource.sendMessage() → POST /conversations/{id}/messages
        mediaPayload: [{'mediaType': MediaType, 'fileName': uploadedFileName}]
```

**Chat Place mapping:**

| MediaType | Place |
|-----------|-------|
| Image (0) | 9 |
| Video (1) | 10 |
| Document (3) | 11 |
| Audio (2) | 12 |

**Voice messages** follow the same pattern: upload audio first (Place=12, FileType=2), then send with `mediaPayload`.

**Key files:**
- `lib/features/chat/data/data_source/chat_remote_data_source.dart`
- `lib/features/chat/data/repo/chat_repo.dart`
- `lib/features/chat/data/model/chat_media_attachment.dart`
- `lib/features/chat/cubit/chat_room/chat_room_cubit.dart`

#### 3. Profile Edit

```
Section → ProfileCubit.updateProfile(file?, formData)
  → if file != null:
      CreatePostRemoteDataSource.uploadImage(file, place: 1)
      → POST attachments/upload-image with Place=1 (UserImages)
      → returns uploaded URL string
  → AuthRepo.updateProfile(UpdateProfileRequest(profileImageUrl: url))
    → AuthRemoteDataSource.updateProfile() → PATCH /Auth/profile/update
```

**Important:** Profile image upload reuses the **create post** upload endpoint with `Place=1` (UserImages). There is **no dedicated profile image upload endpoint**. The profile update endpoint (`PATCH /Auth/profile/update`) accepts only a JSON body with a `profileImageUrl` string — it does NOT accept direct file upload.

**Key files:**
- `lib/features/more/profile/cubit/profile_cubit.dart`
- `lib/features/auth/data/data_source/auth_remote_data_source.dart`
- `lib/features/auth/data/model/update_profile_request.dart`

#### 4. Auth Signup

```
AuthRemoteDataSource.signup(email, password, certificateFile?, syndicateIdFile?)
  → POST /Auth/signup (isFormData: true)
    → Sends JSON fields + MultipartFile for certificate_image and syndicate_id_image
```

**Key file:** `lib/features/auth/data/data_source/auth_remote_data_source.dart`

---

### Flutter Code Examples

#### Upload Single Image (DioConsumer)

```dart
// From ProfileCubit.updateProfile()
final result = await _createPostRemoteDataSource.uploadImage(
  file,
  place: 1,
);

result.fold(
  onSuccess: (imageUrl) {
    // imageUrl is the returned filename string (e.g. "1_guid.jpg")
    final request = UpdateProfileRequest(
      fullName: name,
      profileImageUrl: imageUrl,
      // ...
    );
    _updateProfile(request);
  },
  onFailure: (failure) => emit(ProfileError(failure.userMessage(context))),
);
```

#### Upload Chat Media with Progress

```dart
// From ChatRoomCubit._uploadAttachment()
emit(currentState.copyWith(
  isUploadingMedia: true,
  uploadProgress: 0.0,
));

final result = await chatRepo.uploadChatMedia(
  attachment,
  onProgress: (sent, total) {
    if (state is ChatRoomLoaded) {
      emit((state as ChatRoomLoaded).copyWith(
        uploadProgress: total > 0 ? sent / total : 0.0,
      ));
    }
  },
);

result.fold(
  onSuccess: (fileName) {
    emit(s.copyWith(
      isUploadingMedia: false,
      uploadProgress: 1.0,
      uploadedFileName: fileName,
      uploadedMediaType: attachment.mediaType,
    ));
  },
  onFailure: (failure) => emit(s.copyWith(
    isUploadingMedia: false,
    clearMedia: true,
  )),
);
```

#### Upload Multiple Images

```dart
// From CreatePostRepo.createPostWithMedia()
final imageResults = await Future.wait(
  images.map((media) => _remoteDataSource.uploadMultipleImages(
    media.files,
    place: 2,
  )),
);

final allUrls = imageResults.expand((result) {
  return result.fold(
    onSuccess: (urls) => urls,
    onFailure: (_) => <String>[],
  );
}).toList();
```

#### Pick and Upload File

```dart
// From ChatRoomCubit
Future<void> pickFile() async {
  final file = await _mediaService.pickFiles(allowMultiple: false);
  if (file != null) {
    final attachment = ChatMediaAttachment.document(file);
    _uploadAttachment(attachment);
  }
}
```

---

## Flutter Architecture (Upload Flow)

```
┌─────────────────────────────────────────────────────────────────┐
│  Presentation Layer                                              │
│  Section (BlocBuilder/BlocListener)                              │
│    → Widget (pure UI, no logic)                                  │
├─────────────────────────────────────────────────────────────────┤
│  Cubit (Business Logic)                                          │
│    → Calls Repository methods                                    │
│    → Emits states (sealed class, no Equatable/Freezed)           │
│    → Handles ApiResult via .fold()                               │
├─────────────────────────────────────────────────────────────────┤
│  Data Layer                                                      │
│  Repository                                                      │
│    → Orchestrates multiple data source calls                     │
│    → Merges remote/local data if needed                          │
│  Remote Data Source                                              │
│    → Calls ApiConsumer methods                                   │
│    → Constructs request data with MultipartFile instances         │
├─────────────────────────────────────────────────────────────────┤
│  Network Layer (Core)                                            │
│  ApiConsumer (abstract interface)                                │
│    → DioConsumer (concrete implementation)                       │
│      → FormData.fromMap() → Dio.post()                           │
│      → ErrorHandler.handleDioException() → typed Failure         │
│      → AuthInterceptor (401 → logout)                            │
│      → RetryInterceptor (5xx/timeout → retry)                    │
├─────────────────────────────────────────────────────────────────┤
│  Media Services (Core)                                           │
│  MyMedia (picker) → MediaCompressionService → PostUploadService  │
└─────────────────────────────────────────────────────────────────┘
```

---

## Known Issues & Gotchas

1. **Profile upload reuses create_post endpoint** — `ProfileCubit` calls `CreatePostRemoteDataSource.uploadImage(file, place: 1)`. This works but couples profile to create post infrastructure. Place=1 (UserImages) matches the intended folder, but a dedicated `/Auth/profile/upload-image` endpoint would be cleaner.

2. **No dedicated profile image upload endpoint** — The profile update endpoint (`PATCH /Auth/profile/update`) only accepts a URL string. Any image upload must happen as a separate call first, then the returned filename is passed to the update endpoint.

3. **Update/Replace endpoint unused on mobile** — The `PATCH /api/v1/attachments/update/{name}` endpoint exists on the backend but is **not used** by the current Flutter app. Files are uploaded anew and replaced via separate upload+update calls.

4. **Download endpoint via multipart POST** — The backend download endpoint uses `POST /api/v1/attachments/download` with multipart, but `DioConsumer.downloadFile()` uses Dio's standard GET download. Ensure the backend has a matching GET download route or adapt the Flutter implementation to match.

---

## Backend Architecture Summary (Clean Architecture Layers)

```
┌─────────────────────────────────────────────────────────────────┐
│  API Layer (Controller)                                         │
│  - Receives HTTP request, extracts auth, calls MediatR          │
│  - Returns ApiResponse<T> wrapped result                        │
├─────────────────────────────────────────────────────────────────┤
│  Application Layer (Commands, Handlers, Validators, Interfaces) │
│  - CQRS commands/handlers with validation pipeline              │
│  - IImageValidator, IVideoValidator, IAudioValidator,           │
│    IFileValidator interfaces                                    │
│  - UploadPaths static class maps Place→folder path              │
├─────────────────────────────────────────────────────────────────┤
│  Infrastructure Layer (Implementations)                         │
│  - ImageValidator, VideoValidator, AudioValidator, FileValidator│
│    - Validate file extension                                    │
│    - Call BaseFileService for actual storage                    │
│  - BaseFileService: reads/writes to wwwroot/{folderPath}        │
│  - File named as {Place}_{guid}.ext                             │
└─────────────────────────────────────────────────────────────────┘
```

---

## Configuration (appsettings.json)

```json
{
  "UploadPaths": {
    "DefaultUserImage": "uploads/default",
    "UserImages": "uploads/users",
    "PostImages": "uploads/posts/images",
    "PostVideos": "uploads/posts/videos",
    "PostDocuments": "uploads/posts/documents",
    "ClinicImages": "uploads/clinics/images",
    "ClinicDocuments": "uploads/clinics/documents",
    "DoctorImages": "uploads/doctors/images",
    "DoctorDocuments": "uploads/doctors/documents",
    "MessageImages": "uploads/messages/images",
    "MessageVideos": "uploads/messages/videos",
    "MessageDocuments": "uploads/messages/documents",
    "MessageAudio": "uploads/messages/audio"
  }
}
```

Files are served at runtime via custom `/files` route that maps to `wwwroot/{folderPath}`.
