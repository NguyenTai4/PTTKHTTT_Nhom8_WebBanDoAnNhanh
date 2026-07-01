package com.webbandoan.controller;

import com.webbandoan.dao.DashboardDAO;
import com.webbandoan.model.DashboardDTO;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;


@WebServlet("/export-excel")
public class ExportExcel extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        DashboardDAO dashboardDAO = new DashboardDAO();
        DashboardDTO dashboard = dashboardDAO.getAllDashboard();
        Workbook workbook = new XSSFWorkbook();
        Sheet sheet = workbook.createSheet("BaoCao");
        Row title = sheet.createRow(0);
        title.createCell(0).setCellValue("BÁO CÁO THỐNG KÊ");
        Row header = sheet.createRow(2);
        header.createCell(0).setCellValue("STT");
        header.createCell(1).setCellValue("Danh mục");
        header.createCell(2).setCellValue("Giá trị");

        Row row1 = sheet.createRow(3);
        row1.createCell(0).setCellValue(1);
        row1.createCell(1).setCellValue("Tổng Doanh Thu");
        row1.createCell(2).setCellValue("$1,248.50");

        Row row2 = sheet.createRow(4);
        row2.createCell(0).setCellValue(2);
        row2.createCell(1).setCellValue("Tồn kho");
        row2.createCell(2).setCellValue(48);

        Row row3 = sheet.createRow(5);
        row3.createCell(0).setCellValue(3);
        row3.createCell(1).setCellValue("Tổng số Khách Hàng");
        row3.createCell(2).setCellValue(dashboard.getTotalCustomers());

        Row row4 = sheet.createRow(6);
        row4.createCell(0).setCellValue(4);
        row4.createCell(1).setCellValue("Chưa Xử Lý");
        row4.createCell(2).setCellValue(7);

        for (int i = 0; i < 3; i++) {
            sheet.autoSizeColumn(i);
        }
        resp.setContentType(
                "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
        resp.setHeader(
                "Content-Disposition",
                "attachment; filename=Dashboard.xlsx");
        workbook.write(resp.getOutputStream());
        workbook.close();
    }
}
