function copyVoucher(code){
    navigator.clipboard.writeText(code)
    .then(() => {
        alert("Đã sao chép mã: "+code)
    })
        .catch(err => {
            console.error(err)
            alert("Không thể sao chép mã.");
        })
}