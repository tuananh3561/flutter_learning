Dữ liệu cho một câu chuyện tương tác . 

**1. Cấu Trúc Tổng Quan:**

*   **`root.json`:** Đây dường như là file chính, chứa thông tin tổng quan về câu chuyện.
*   **`4063_1_*.json`:** Các file này là các trang/phần của câu chuyện.  Số cuối cùng (1, 2, 3, ...)  là thứ tự của trang.

**2. Nội Dung `root.json`:**

*   `fontname`:  Đường dẫn đến file font chữ được sử dụng.
*   `illustratedby`: Thông tin về người minh họa:
    *   `audio`: Đường dẫn file âm thanh (là giọng đọc/giới thiệu của người minh họa).
    *   `duration`: Thời lượng của file âm thanh (tính bằng giây).
    *   `illustratedby`: Tên người minh họa.
*   `title`: Thông tin về tiêu đề:
    *   `audio`: Đường dẫn đến file âm thanh của tiêu đề.
*   `sync_data`: Mảng các đối tượng, mỗi đối tượng đồng bộ hóa một từ với thời gian trong file âm thanh tiêu đề:
    *   `e`: Thời điểm kết thúc của từ (mili giây).
    *   `s`: Thời điểm bắt đầu của từ (mili giây).
    *   `te`: Thời điểm kết thúc của từ (trong một đơn vị khác, là khung hình).
    *   `ts`: Thời điểm bắt đầu của từ (trong một đơn vị khác, là khung hình).
    *   `w`: Từ đó.
*   `title`:  Tiêu đề của câu chuyện ("I Love Green").
*   `version_story`:  Phiên bản của câu chuyện.
*   `writentby`:  Thông tin về tác giả:
    *   `audio`: Đường dẫn file âm thanh (là giọng đọc/giới thiệu của tác giả).
    *   `duration`: Thời lượng file âm thanh.
    *   `writentby`: Tên tác giả.

**3. Nội Dung các file `4063_1_*.json` (Trang/Phần của Câu Chuyện):**

Các file này có cấu trúc giống nhau, mô tả nội dung của từng trang:

*   `audio`:  Mảng chứa thông tin về phần âm thanh chính của trang:
    *   `path`: Đường dẫn đến file âm thanh (giọng đọc).
    *   `pause`:  (Hiện tại là `null`,  dùng để chỉ định tạm dừng sau này).
    *   `start`:  Thời điểm bắt đầu (hiện tại là 0).
    *   `sync`: Mảng các đối tượng đồng bộ hóa từng từ với thời gian trong file âm thanh (giống như `sync_data` trong `root.json`).
*   `bg_img`: Thông tin về ảnh nền:
    *   `path`: Đường dẫn file ảnh nền.
    *   `position`: Vị trí (tọa độ) của ảnh nền.
*   `box_type`: (Bỏ qua không sử dụng) Kiểu hộp văn bản ( là định dạng hiển thị).
*   `fontsize`: Cỡ chữ.
*   `highlight_color`: Màu highlight ( dùng để làm nổi bật từ khi đọc).
*   `image`: Mảng các đối tượng hình ảnh tương tác trên trang:
    *   `animation_order`: Thứ tự animation.
    *   `animation_reset`:  Đặt lại animation.
    *   `animation_type`:  Loại animation ("end" có nghĩa là animation khi kết thúc tương tác).
    *   `audio`: Âm thanh khi tương tác với hình ảnh:
        *   `duration`:  Thời lượng.
        *   `path`: Đường dẫn file âm thanh.
        *   `text`:  Văn bản liên quan (ví dụ: tên đối tượng).
        *   `w_text`:  (Chưa rõ,  là trọng số).
    *   `contentsize`:  Kích thước nội dung.
    *   `effect`: Hiệu ứng.
    *   `path`: Đường dẫn file ảnh (hiện tại để trống,  là ảnh động).
    *   `position`: Vị trí.
    *   `repeat_animation`: Lặp lại animation.
    *   `sequence`: Chuỗi animation.
    *   `star_order`: Thứ tự.
    *   `touch`:  Thông tin về tương tác chạm:
        *   `boundingbox`:  Hộp giới hạn khu vực tương tác.
        *   `star_position`:  Vị trí.
        *   `vertices`: Tọa độ các đỉnh (nếu là hình đa giác).
    *   `touchable`:  tương tác hay không.
    *   `type`:  Loại phần tử ("layout").
    *   `z_order`: Thứ tự hiển thị (lớp).
* `line_height`: Chiều cao dòng.
*   `normal_color`:  Màu chữ bình thường.
*   `text`: Mảng chứa văn bản trên trang:
    *   `boundingbox`: Hộp giới hạn của văn bản.
    *   `config_audio`: (Bỏ qua không sử dụng) (Mảng ân thanh dùng để thay thế từ VD : text='I love green. I love green so much.' config_image=[{`text`:'love', `image`: 'love.mp3'}] thay thế tư love bằng ảnh trong text).
    *   `config_image`: (Bỏ qua không sử dụng) (Mảng hình ảnh dùng để thay thế từ VD : text='I love green. I love green so much.' config_image=[{`text`:'love', `image`: 'love.png'}] thay thế tư love bằng ảnh trong text).
    *   `end`: (Bỏ qua không sử dụng) (Chưa rõ).
    *    `start`: (Bỏ qua không sử dụng) (Chưa rõ).
    *   `text`: Nội dung văn bản.


