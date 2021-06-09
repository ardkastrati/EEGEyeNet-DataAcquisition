if correct_resp(pp,resp_b) == squeeze(par.activated_resp(pp,resp_b ,1))
    disp(['Trial',num2str(resp_b), ': Correct'])
    if isnan(errorcor(pp,resp_b))
        errorcor(pp,resp_b) = 0;
    else
        errorcor(pp,resp_b) = errorcor(pp,resp_b)+1;
    end
else
    disp(['Trial',num2str(pp,resp_b), ': Wrong'])
    if isnan(errorcor(pp,resp_b))
        errorcor(pp,resp_b) = 0;
    else
        errorcor(pp,resp_b) = errorcor(pp,resp_b)+1;
    end
end