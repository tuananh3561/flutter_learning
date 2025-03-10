**1. Tổng Quan (Overview)**

*   **Tên Game:** Multiple Choice
*   **Thể Loại:** Educational Game (Game giáo dục), Vocabulary Learning (Học từ vựng)
*   **Mục Tiêu Trò Chơi:** Giúp người chơi ôn luyện và học từ vựng thông qua các thử thách âm thanh và hình ảnh. Người chơi cần ghép đúng âm thanh với hình ảnh tương ứng.
*   **Đối Tượng Mục Tiêu:** Trẻ em, người học tiếng Anh ở trình độ sơ cấp.
*   **Nền Tảng:** Mobile (iOS, Android)
*   **Phong cách đồ họa**: Hoạt hình, 2D

**2. Gameplay (Lối Chơi)**

*   **Vòng Lặp Cốt Lõi (Core Loop):**
    1.  **Nhìn:** Hiển thị hình ảnh minh hoạ từ vừ vụng (ví dụ : sử tử , rùa).
    1.  **Nghe:** Nghe audio phát âm một từ vựng.
    2.  **Nhận Diện:** Nhận diện tư vựng phù hợp với hình ảnh nghe.
    3.  **Kéo và Thả (Drag and Drop):** Kéo nút audio chứa âm thanh vào vị trí tương ứng (ô drop dưới hình ảnh).
    4.  **Phản Hồi:** Nhận phản hồi về kết quả (đúng/sai).
    5.  **Tiến Tới:** Chuyển sang từ vựng tiếp theo.
    6.  **Lượt chơi:** Trò chơi có nhiều lượt, và kết thúc thi người chơi hoàn thành 5 lượt .

*   **Các Yếu Tố Chính (Key Elements/Features):**
    *   **Hình ảnh:** Các hình ảnh minh họa từ vựng (ví dụ: sư tử, rùa).
    *   **Âm thanh:** Các file audio phát âm từ vựng.
    *   **Ô Drop:** Ô trống để người chơi kéo nút audio chứa âm thanh vào.
    *   **Máy Bay:** Chiếc máy bay màu đỏ, mỗi khi trả lời đúng 1 lượt sẽ play 1 amin Spine máy bay.
    *   **Nút Audio:** Nút để phát lại âm thanh của từ vựng.

*   **Luật Chơi (Rules):**
    *   Người chơi phải kéo đúng nút audio chưa âm thanh vào vị trí tưng ứng (ô drop) mô tả hình ảnh .
    *   Số lượng đáp án có thể (2 đáp án, 3 đáp án, 4 đáp án ...) đựa theo config.
    *   Nếu sai có thêm cơ hội sửa lại .

*   **Điều Kiện Thắng/Thua/Kết Thúc (Win/Lose/End Conditions):**
    *   **Thắng:** Hoàn thành tất cả các từ vựng trong một lượt chơi.
    *   **Thua:** Không có điều kiên thua.
    *   **Kết Thúc:** Hoàn thành tất cả các lượt chơi. Sau khi kết thúc, nhân vật Max nhảy lên máy bay và bay đi (play amin Spine máy bay).

**3. Giao Diện và Điều Khiển (UI/UX)**

*   **Điều Khiển (Controls):**
    *   **Chạm (Tap):** Chạm vào nút audio để phát âm thanh.
    *   **Kéo và Thả (Drag and Drop):** Nut Audio vào ô drop dưới hình ảnh.

*   **Giao Diện (User Interface):**
    *   **Bố cục (Layout):**
        *   Màn hình Intro:  Hiển thị Máy Bay (amin Spine máy bay hiển thị).
        *   Màn hình Gameplay: Hình ảnh, nút audio, các ô drop trống.
        *   Màn hình Kết Thúc: Hoạt ảnh Max nhảy lên máy bay (amin Spine máy bay).
    *   **Phong cách hình ảnh (Visual Style):** Hoạt hình, màu sắc tươi sáng, phù hợp với trẻ em.
    *   **Các thành phần:**
        *   Nút bấm (audio, play)
        *   Hình ảnh từ vựng.
        *   Ô trống cho drop
    *   **Hoạt ảnh (Animations):**
        *   Hoạt ảnh kéo và thả hình ảnh.
        *   Hoạt ảnh Max nhảy lên máy bay.
        *   Hoạt ảnh cho đúng/sai.

**4. Âm Thanh (Audio)**

*   **Nhạc Nền (Background Music):** Nhạc nền vui nhộn, nhẹ nhàng, phù hợp với trẻ em. Phát liên tục trong suốt trò chơi.
*   **Hiệu Ứng Âm Thanh (Sound Effects - SFX):**
    *   `SFX click`: Khi chạm vào các nút.
    *   `SFX đúng`: Khi ghép đúng hình ảnh.
    *   `SFX sai`: Khi ghép sai hình ảnh.
    *   `SFX yeah`: Có thể dùng khi hoàn thành một màn chơi.
    *   `SFX popup`: Khi popup hiện ra.
    *   `SFX Máy bay bay + khi Max`: Play khi Amin Spine: Máy Bay (4.0 - Max len may bay [Phone], 4.0 - Max len may bay [Tablet])
    *   `SFX tia sét`: Play khi Amin Spine: Máy Bay (4.0 - Max len may bay [Phone], 4.0 - Max len may bay [Tablet])
    *   `SFX ghép bộ phận`: Play khi Spine Amin: Máy Bay (1.0 - Lap canh to [Phone], 1.0 - Lap canh to [Tablet], 2.0 - Lap canh nho va duoi [Phone], 2.0 - Lap canh nho va duoi [Tablet], 3.0 - Lap canh quat [Phone], 3.0 - Lap canh quat ).
    *   `SFX Max nhảy lên máy bay`: Play khi Amin Spine: Máy Bay (4.0 - Max len may bay [Phone], 4.0 - Max len may bay [Tablet])
    *   `SFX máy bay bay đi`: Play khi Amin Spine: Máy Bay (4.0 - Max len may bay [Phone], 4.0 - Max len may bay [Tablet])

* **Âm thanh trong game:** Các file ghi âm phát âm từ vựng cần rõ ràng, dễ nghe.

**5. Phân Tích Kỹ Thuật (Technical Analysis)**

*   **Logic:**
    *   Xử lý sự kiện chạm/kéo/thả.
    *   Kiểm tra tính đúng/sai của đáp án.
    *   Quản lý tiến trình của trò chơi (lượt chơi, từ vựng).
    *   Điều khiển hoạt ảnh và âm thanh.
*   **Thời Gian (Timing):**
    *   Thời gian hiển thị hình ảnh/âm thanh.
    *   Thời gian chờ phản hồi từ người chơi.
*   **Công Nghệ (Technology):**
    *   Game Engine: flame
    *   Amin : flame_spine

**6. Danh Mục Tài Sản (Asset List)**

*   **Hình ảnh:**
    *   `assets/Multiple Choice/background.png`: Các hình nền cho trò chơi.
    *   `assets/images/word`: Hình ảnh word.
*   **Âm thanh:**
    *   `assets/Multiple Choice/SFX click.wav`: SFX click.
    *   `assets/Multiple Choice/SFX đúng.mp3`: SFX đúng.
    *   `assets/Multiple Choice/SFX ghép bộ phận.wav`: SFX ghép các bộ phân máy bay.
    *   `assets/Multiple Choice/SFX Max nhảy lên máy bay.mp3`: SFX max nhảy lên máy bay.
    *   `assets/Multiple Choice/SFX máy bay bay đi.mp3`: SFX máy bay bay đi.
    *   `assets/Multiple Choice/SFX popup.mp3`: SFX popup.
    *   `assets/Multiple Choice/SFX sai.wav`: SFX sai.
    *   `assets/Multiple Choice/SFX tia sét.mp3`: SFX tia sét.
    *   `assets/Multiple Choice/SFX yeah.mp3`: SFX yeah.
    *   `assets/audio/word/`: Thư mục chưa audio word.
*   **Amin Spine: Máy Bay**
    *   `assets/Multiple Choice/May bay/Multiple choice_v2_hdr.atlas.txt`: 
    *   `assets/Multiple Choice/May bay/Multiple choice_v2.json`: 
    *   `animations`: 1.0 - Lap canh to [Phone], 1.0 - Lap canh to [Tablet], 2.0 - Lap canh nho va duoi [Phone], 2.0 - Lap canh nho va duoi [Tablet], 3.0 - Lap canh quat [Phone], 3.0 - Lap canh quat [Tablet], 4.0 - Max len may bay [Phone], 4.0 - Max len may bay [Tablet]