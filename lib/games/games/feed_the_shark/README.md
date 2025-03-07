**Game**

Feed the Shark

**Mục Tiêu Trò Chơi:**

Người chơi cần "cho cá mập ăn" bằng cách chạm vào con cá có từ hoặc âm thanh phù hợp với yêu cầu.  Trò chơi có nhiều lượt, và kết thúc khi người chơi chọn đúng một số lượng cá nhất định (ví dụ: 5 con).

**Phân Tích:**

1.  **Intro Game (Màn Hình Giới Thiệu):**

    *   **Hình ảnh:**  Có vẻ như màn hình giới thiệu có hình ảnh các con cá bơi lội.
    *   **Âm thanh:**  Nhạc nền (BG) và hiệu ứng âm thanh (SFX) xuyên suốt trò chơi.
    *   **Logic:**
        *   Các con cá xuất hiện ngẫu nhiên trên 4 đường thẳng từ hai phía (trái/phải) của màn hình.
        *   Trên mỗi đường thẳng sẽ chỉ có 1 con cá xuất hiện.
        *   Có độ trễ (delay) giữa các lần xuất hiện cá.
        *   Các con cá sẽ di chuyển từ từ trái/phải màn hình xang phía còn lại.
        *   Nếu con các di chuyển vượt quá màn hình 50px, sẽ bị ẩn đi và con cá khác sẽ xuất hiện thay thế con cá đó sau 1s.
        *   Có 4 con cá luôn hiển thị trên màn hình.
        *   Khi trò âm thanh đáp án đúng sẽ được phát (SFX).
        *   Đáp án đúng xuất hiện ngẫu nhiên trong 4 con cá .
        *   Có cơ chế "thay thế":  Khi 1 con cá bị ẩn (đi ra khỏi màn hình), 1 con cá khác sẽ xuất hiện đi từ ngoài màn hình vào.

2.  **Ingame (Trong Trò Chơi):**

    *   **Hình ảnh:** Ảnh nền (bg\_img) với các con cá.
    *   **Tương tác:**
        *   Người chơi chạm (tap) vào các con cá.
        *   Chạm đúng: Con cá được cọn sẽ choáng váng (có animation spine con cá choáng váng) sau đó Cá mập sẽ lao tư ngoài màn hình vào ăn con cá đó (có animation spine cá mập ăn) sau đó cá mập bơi ra khỏi màn hình (có animation spine cá mập idie).
        *   Chạm sai: Con cá sẽ rung lên (có animation spine cá rung lên) sau đó phát audio ẩn trong cá và con cá bơi nhanh ra khỏi nàm hình (có animation spine cá idie).
    *   **Logic:**
        *   Mỗi con cá có một từ liên kết với cá VD (`text`:"dog", `audio`: 'dog.mp3').
        *   Khi chạm đúng, âm thanh phản hồi (SFX) sẽ được phát.

3.  **Endgame (Kết Thúc Trò Chơi):**

    *   **Hình ảnh:** Cá mập bơi ra giữa màn hình.  Có hiệu ứng hình ảnh (sao biển rơi).
    *   **Âm thanh:**  Hiệu ứng âm thanh chiến thắng.

**Asset game:**
Spine bong bóng: assets/Feed the Shark/bong bong/4.1-3.8/
Spine cá nhỏ 1: assets/Feed the Shark/ca nho 1/4.1-3.8/
Spine cá nhỏ 2: assets/Feed the Shark/ca nho 2/4.1-3.8/
Spine cá nhỏ 3: assets/Feed the Shark/ca nho 3/4.1-3.8/
Spine cá to 1: assets/Feed the Shark/ca to 1/4.1-3.8/
Spine cá to 2:assets/Feed the Shark/ca to 2/4.1-3.8/
Spine cá to 3: assets/Feed the Shark/ca to 3/4.1-3.8/
Spine rong bien 1: assets/Feed the Shark/rong bien 1/4.1-3.8/
Spine rong bien 2: assets/Feed the Shark/rong bien 2/4.1-3.8/
Spine shark: assets/Feed the Shark/shark/4.1-3.8/
Spine star: assets/Feed the Shark/star/4.1-3.8/
âm thanh nhạc nền: assets/Feed the Shark/Nhạc BG.mp3
âm thanh nhạc cá mập ăn: assets/Feed the Shark/SFX cá mập.mp3
âm thanh nhạc click: assets/Feed the Shark/SFX Click.mp3
âm thanh nhạc đúng: assets/Feed the Shark/SFX đúng.mp3
âm thanh nhạc guiding: assets/Feed the Shark/SFX guiding.mp3
âm thanh nhạc hết lượt: assets/Feed the Shark/SFX hết lượt 1.mp3
âm thanh nhạc sai: assets/Feed the Shark/SFX sai.mp3
âm thanh nhạc unclick: assets/Feed the Shark/SFX Unclick.mp3
âm thanh nhạc win: assets/Feed the Shark/SFX Win.mp3